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

class LoginViewReactor: Reactor {

  enum Action {
  }

  enum Mutation {
    // mutation cases
  }

  struct State {
    var isAuthenticated: Bool?
    var loggedIn: Bool = false
  }

  let initialState = State()

  fileprivate let authService: AuthServiceType

  init(authService: AuthServiceType) {
    self.authService = authService
  }

  func mutate(action: Action) -> Observable<Mutation> {
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    // switch mutation {
    // }
    return newState
  }

  func facebookLogin() {

  }
}
