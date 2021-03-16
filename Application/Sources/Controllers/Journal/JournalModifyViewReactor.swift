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
    case updateBeerKindCode(Code)
    case updateBeerTypeCode(Code)
  }

  enum Mutation {
    case setBeerKind(Code)
    case setBeerType(Code)
  }

  struct State {
    var beerKindCode: Code?
    var beerTypeCode: Code?
  }

  let initialState = State()

  init(id: String?, service: JournalService) {
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .updateBeerKindCode(code):
      return .just(.setBeerKind(code))

    case let .updateBeerTypeCode(code):
      return .just(.setBeerType(code))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state

    switch mutation {
    case let .setBeerKind(code):
      state.beerKindCode = code

    case let .setBeerType(code):
      state.beerTypeCode = code
    }

    return state
  }
}
