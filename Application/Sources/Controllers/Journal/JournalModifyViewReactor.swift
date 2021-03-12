//
//  JournalModifyViewReactor.swift
//  Application
//
//  Created by bongzniak on 2021/03/08.
//
//

import Foundation
import ReactorKit
import RxSwift

final class JournalModifyViewReactor: Reactor {

  enum Action {
  }

  enum Mutation {
  }

  struct State {
  }

  let initialState = State()

  init(id: String?, service: JournalService) {
  }

  func mutate(action: Action) -> Observable<Mutation> {
    // switch action {
    // }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    state
  }
}
