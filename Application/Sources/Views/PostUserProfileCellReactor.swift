//
// Created by bongzniak on 2021/03/02.
//

import Foundation

import Pure
import ReactorKit
import RxSwift

final class PostUserProfileCellReactor: Reactor {

  enum Action {
  }

  enum Mutation {
  }

  struct State {
    var profileUrl: URL?
    var nickname: String
  }

  let initialState: State

  init(user: UserViewModel) {
    log.info("user.profileUrl: \(user.profileUrl)")
    initialState = State(
      profileUrl: URL(string: user.profileUrl),
      nickname: user.nickname
    )
  }

  func mutate(action: Action) -> Observable<Mutation> {
    // switch action {
    // }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
//    switch mutation {
//    }
    return state
  }
}
