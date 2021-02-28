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

final class PostListViewReactor: Reactor {

  enum Action {
    case refresh
    case next(page: Int)
  }

  enum Mutation {
    case setPosts([Post])
    case appendPosts([Post])
    case setLoading(Bool)
  }

  struct State {
    var isRefreshing: Bool = false
    var isLoading: Bool = false
    var page: Int = 0
    var sections: [PostListSection] = []
  }

  let initialState = State()

  let postService: PostServiceType

  init(postService: PostServiceType) {
    self.postService = postService
  }

  func mutate(action: Action) -> Observable<Mutation> {
    let startLoading = Observable<Mutation>.just(.setLoading(true))
    let endLoading = Observable<Mutation>.just(.setLoading(false))

    switch action {
    case .refresh:
       let setPosts = postService.posts(page: 0, size: 0)
         .asObservable()
         .map { posts -> Mutation in
           .setPosts(posts)
         }
      return .concat([startLoading, setPosts, endLoading])

    case let .next(page):
      let appendPosts = postService.posts(page: page, size: 0)
        .asObservable()
        .map { posts -> Mutation in
          .appendPosts(posts)
        }
      return .concat([startLoading, appendPosts, endLoading])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .setLoading(isLoading):
      state.isLoading = isLoading
    case let .setPosts(posts):
      state.sections = posts.map { PostListSection.post($0) }
    case let .appendPosts(posts):
      let appendSections = posts.map { PostListSection.post($0) }
      state.sections.append(contentsOf: appendSections)
    }
    return state
  }
}
