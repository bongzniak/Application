//
//  LoginViewReactor.swift
//  Application
//
//  Created by bongzniak on 2021/02/23.
//
//

import Foundation
import ReactorKit
import RxSwift
import FBSDKLoginKit

final class LoginViewReactor: Reactor {

  enum Action {
    case facebookLogin(viewController: UIViewController)
  }

  enum Mutation {
    case setLoggedIn(Bool)
  }

  struct State {
    var isLoggedIn: Bool?
  }

  let initialState = State()

  fileprivate let authService: AuthServiceType

  init(authService: AuthServiceType) {
    self.authService = authService
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .facebookLogin(viewController):
      return facebookAccess(viewController: viewController)
        .asObservable()
        .flatMap { self.authService.facebookAuthority(token: $0) }
        .map { _ in true }
        .catchErrorJustReturn(false)
        .map(Mutation.setLoggedIn)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .setLoggedIn(isLoggedIn):
      state.isLoggedIn = isLoggedIn
      return state
    }
  }
}

extension LoginViewReactor {
  private func facebookAccess(viewController: UIViewController) -> Observable<String> {
    Observable.create { observer -> Disposable in
      let permissions = ["public_profile", "email"]
      LoginManager.init().logIn(permissions: permissions, from: viewController) { result, error in
        guard let result = result,
              let token = result.token?.tokenString,
              let isExpired = result.token?.isExpired,
              (error == nil) || token.isEmpty || isExpired
        else {
          Disposables.create()
          return
        }

        observer.onNext(token)
        observer.onCompleted()
      }

      return Disposables.create()
    }
  }
}
