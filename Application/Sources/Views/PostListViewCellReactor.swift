//
//  PostListViewCellReactor.swift
//  Application
//
//  Created by bongzniak on 2021/02/28.
//
//

import Foundation
import ReactorKit
import RxSwift
import Pure

final class PostListViewCellReactor: Reactor {

  enum Action {
  }

  enum Mutation {
  }

  struct State {
    var contents: String
  }

  let initialState: State

  init(post: Post) {
    initialState = State(contents: post.contents)
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
