//
//  SplashReactor.swift
//  MyApp
//
//  Created by bongzniak on 2020/12/21.
//

import ReactorKit
import RxCocoa
import RxSwift

final class SplashViewReactor: Reactor {

  enum Action {
    case checkIfAuthenticated
  }

  enum Mutation {
    case setAuthenticated(Bool)
  }

  struct State {
    var isAuthenticated: Bool?
  }

  let initialState = State()

  fileprivate let authService: AuthServiceType
  fileprivate let appStoreService: AppStoreServiceType

  init(appStoreService: AppStoreServiceType, authService: AuthServiceType) {
    self.authService = authService
    self.appStoreService = appStoreService
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .checkIfAuthenticated:
      return Observable.just(true).map(Mutation.setAuthenticated)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .setAuthenticated(isAuthenticated):
      state.isAuthenticated = isAuthenticated
      return state
    }
  }
}
