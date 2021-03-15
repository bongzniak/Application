//
//  CodeListViewCellCellReactor.swift
//  Application
//
//  Created by bongzniak on 2021/03/15.
//
//

import Foundation
import ReactorKit
import RxSwift

final class CodeListViewCellReactor: Reactor {

  enum Action {
  }

  enum Mutation {
  }

  struct State {
    let groupCodeType: GroupCodeType
    var code: Code
  }

  let initialState: State

  fileprivate var code: Code {
    currentState.code
  }

  init(groupCodeType: GroupCodeType, code: Code) {
    initialState = State(groupCodeType: groupCodeType, code: code)
  }

  func mutate(action: Action) -> Observable<Mutation> {
    // switch action {
    // }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    // switch mutation {
    // }
    return state
  }
}
