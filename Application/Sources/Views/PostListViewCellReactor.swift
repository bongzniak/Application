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
    case setPost(Post)
  }

  struct State {
    var imageURL: URL?
    var title: String
    var contents: String
    var commentCount: Int
    var likeCount: Int
  }

  let initialState: State

  init(post: Post) {
    initialState = State(
      imageURL: URL(string: post.images.first ?? ""),
      title: post.title,
      contents: post.contents,
      commentCount: post.commentCount,
      likeCount: post.likeCount
    )
  }

  func mutate(action: Action) -> Observable<Mutation> {
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case .setPost(let post):
      state.contents = post.contents
    }
    return state
  }
}
