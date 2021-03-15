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

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let event = Code.event.flatMap { [weak self] event in
      self?.mutation(from: event) ?? .empty()
    }
    return Observable.of(mutation, event).merge()
  }

  func mutation(from event: Code.Event) -> Observable<Mutation> {
    switch event {
    case let .selectedCode(groupCodeType, code):
      log.info("groupCodeType: \(groupCodeType) : code: \(code)")
      return .empty()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    state
  }
}
