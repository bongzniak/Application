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
    case refresh
  }

  enum Mutation {
    case setRefreshing(Bool)
    case setCodes([Code])
  }

  struct State {
    let groupCodeType: GroupCodeType
    var isRefreshing: Bool = false
    var sections: [CommonListSection] = []
  }

  let initialState: State

  let commonService: CommonServiceType

  init(commonService: CommonServiceType, groupCodeType: GroupCodeType) {
    self.commonService = commonService
    initialState = State(groupCodeType: groupCodeType)
  }

  fileprivate var groupCodeType: GroupCodeType {
    currentState.groupCodeType
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .refresh:
      let startRefreshing = Observable<Mutation>.just(.setRefreshing(true))
      let endRefreshing = Observable<Mutation>.just(.setRefreshing(false))
      let setCodes = commonService.codes(groupCodeType: groupCodeType)
        .asObservable()
        .map { codes -> Mutation in
          .setCodes(codes)
        }
      return .concat([startRefreshing, setCodes, endRefreshing])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch  mutation {
    case let .setRefreshing(isRefreshing):
      state.isRefreshing = isRefreshing
    case let .setCodes(codes):
      state.sections = codes.map { CommonListSection.codeListCell($0) }
    }
    return state
  }
}
