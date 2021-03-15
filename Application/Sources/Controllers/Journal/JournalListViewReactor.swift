//
//  PostListViewReactor.swift
//  Application
//
//  Created by bongzniak on 2021/02/27.
//
//

import Foundation
import ReactorKit
import RxSwift

final class JournalListViewReactor: Reactor {

  enum Action {
    case refresh
    case next(page: Int)
  }

  enum Mutation {
    case setBeers([Beer])
    case appendBeers([Beer])
    case setLoading(Bool)
  }

  struct State {
    var isRefreshing: Bool = false
    var isLoading: Bool = false
    var sections: [JournalListSection] = []
  }

  let initialState = State()

  let journalService: JournalServiceType

  init(journalService: JournalServiceType) {
    self.journalService = journalService
  }

  func mutate(action: Action) -> Observable<Mutation> {
    let startLoading = Observable<Mutation>.just(.setLoading(true))
    let endLoading = Observable<Mutation>.just(.setLoading(false))

    switch action {
    case .refresh:
       let setPosts = journalService.journals(page: 0, size: 0)
         .asObservable()
         .map { beers -> Mutation in
           .setBeers(beers)
         }
      return .concat([startLoading, setPosts, endLoading])

    case let .next(page):
      let appendPosts = journalService.journals(page: page, size: 0)
        .asObservable()
        .map { beers -> Mutation in
          .appendBeers(beers)
        }
      return .concat([startLoading, appendPosts, endLoading])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .setLoading(isLoading):
      state.isLoading = isLoading
    case let .setBeers(beers):
      state.sections = beers.map { JournalListSection.post($0) }
    case let .appendBeers(beers):
      let appendSections = beers.map { JournalListSection.post($0) }
      state.sections.append(contentsOf: appendSections)
    }
    return state
  }
}
