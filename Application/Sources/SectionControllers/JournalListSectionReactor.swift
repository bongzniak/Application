//
//  PostListSectionReactor.swift
//  Application
//
//  Created by bongzniak on 2021/02/28.
//
//

import Foundation
import ReactorKit
import RxSwift

final class JournalListSectionReactor: Reactor {

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
    var newState = state
    // switch mutation {
    // }
    return newState
  }
}
