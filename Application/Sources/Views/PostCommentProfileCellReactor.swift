//
// Created by bongzniak on 2021/03/02.
//

import Foundation

import Pure
import ReactorKit
import RxSwift

final class PostCommentProfileCellReactor: Reactor {

  enum Action {
  }

  enum Mutation {
  }

  struct State {
    var profileUrl: URL?
    var nickname: String
    var contents: String
  }

  let initialState: State

  init(comment: CommentViewModel) {
    initialState = State(
      profileUrl: URL(string: ""),
      nickname: comment.userNickname,
      contents: comment.contents
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
