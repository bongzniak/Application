//
//  JournalListViewCellReactor.swift
//  Application
//
//  Created by bongzniak on 2021/02/28.
//
//

import Foundation
import ReactorKit
import RxSwift
import Pure

final class JournalListViewCellReactor: Reactor {

  enum Action {
  }

  enum Mutation {
    case setBeer(Beer)
  }

  struct State {
    var beer: Beer
  }

  let initialState: State

  init(beer: Beer) {
    initialState = State(beer: beer)
  }

  func mutate(action: Action) -> Observable<Mutation> {
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case .setBeer(let beer):
      state.beer = beer
    }
    return state
  }
}
