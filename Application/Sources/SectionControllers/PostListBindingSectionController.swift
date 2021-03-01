//
//  PostListBindingSectionController.swift
//  Application
//
//  Created by bongzniak on 2021/03/01.
//
//

import Foundation
import UIKit

import Pure
import ReactorKit
import AsyncDisplayKit
import IGListKit
import RxSwift
import RxCocoa_Texture

final class PostListBindingSectionController: ListBindingSectionController<Post>,
  FactoryModule, View {

  typealias Node = PostListBindingSectionController
  typealias Reactor = PostListBindingSectionReactor

  // MARK: Dependency

  struct Dependency {
    let reactor: Reactor
    let postListViewCellNodeFactory: PostListViewCellNode.Factory
  }

  // MARK: Constants

  // MARK: Properties

  var disposeBag = DisposeBag()

  let postListViewCellNodeFactory: PostListViewCellNode.Factory

  // MARK: Node

  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    defer { reactor = dependency.reactor }
    postListViewCellNodeFactory = dependency.postListViewCellNodeFactory

    super.init()

    dataSource = self
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Configuring

  func bind(reactor: Reactor) {
  }
}

// MARK: - ListBindingSectionControllerDataSource, ASSectionController

extension PostListBindingSectionController: ListBindingSectionControllerDataSource,
  ASSectionController {

  func sectionController(
    _ sectionController: ListBindingSectionController<ListDiffable>,
    viewModelsFor object: Any
  ) -> [ListDiffable] {
    guard let post = self.object as? Post
    else {
      return []
    }

    let today = Date()
    let formatter1 = DateFormatter()
    formatter1.dateStyle = .short
    let id = formatter1.string(from: today)

    let user = UserViewModel(id: id, nickname: "", profileUrl: "", datetime: "")
    let comment1 = CommentViewModel(
      id: id,
      userID: "test: \(id)",
      userNickname: "bongzniak",
      contents: "contents",
      datetime: "Today"
    )
    let comment2 = CommentViewModel(
      id: id,
      userID: "test: \(id)",
      userNickname: "bongzniak",
      contents: "contents",
      datetime: "Today"
    )

    return [user, comment1, comment2]
  }

  func sectionController(
    _ sectionController: ListBindingSectionController<ListDiffable>,
    cellForViewModel viewModel: Any, at index: Int
  ) -> UICollectionViewCell & ListBindable {
    // swiftlint:disable force_cast
    ASIGListSectionControllerMethods.cellForItem(
      at: index,
      sectionController: self
    ) as! UICollectionViewCell & ListBindable
    // swiftlint:enable force_cast
  }

  func sectionController(
    _ sectionController: ListBindingSectionController<ListDiffable>,
    sizeForViewModel viewModel: Any, at index: Int
  ) -> CGSize {
    ASIGListSectionControllerMethods.sizeForItem(at: index)
  }

  func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
    { [weak self] in
      guard let `self` = self else { return ASCellNode() }

      return self.nodeForItem(at: index)
    }
  }

  func nodeForItem(at index: Int) -> ASCellNode {
    if let post = viewModels[index] as? Post {
      return postListViewCellNodeFactory.create(payload: .init(post: post))
    }
    if viewModels[index] is UserViewModel {
      return PostUserProfileCellNode()
    }
    if viewModels[index] is CommentViewModel {
      return PostCommentProfileCellNode()
    }

    return ASCellNode()
  }
}
