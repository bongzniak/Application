//
//  CodeListViewReactor.swift
//  Application
//
//  Created by bongzniak on 2021/03/09.
//
//

import Foundation
import ReactorKit
import RxSwift

final class CodeListViewReactor: Reactor {

  enum Action {
  }

  enum Mutation {
  }

  struct State {
  }

  let initialState = State()

  init() {
  }

  func mutate(action: Action) -> Observable<Mutation> {
    // switch action {
    // }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    state
  }
}
