//
//  JournalViewReactor.swift
//  Application
//
//  Created by bongzniak on 2021/03/05.
//
//

import Foundation
import ReactorKit
import RxSwift

final class JournalViewReactor: Reactor {

  enum Action {
    case refresh
  }

  enum Mutation {
    case setBeer(Beer)
  }

  struct State {
    let beerID: String
    var isLoading: Bool = false
    var isRefreshing: Bool = false
    var beer: Beer?

    init(beerID: String) {
      self.beerID = beerID
    }
  }

  let initialState: State

  fileprivate var beerID: String {
    currentState.beerID
  }
  let journalService: JournalServiceType

  init(
    beerID: String,
    journalService: JournalServiceType
  ) {
    initialState = State(beerID: beerID)
    self.journalService = journalService
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .refresh:
      let setBeer = journalService.journal(id: beerID)
        .asObservable()
        .map { beer -> Mutation in
          .setBeer(beer)
        }
      return .concat([setBeer])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .setBeer(beer):
      state.beer = beer
    }
    return state
  }
}
