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
    let postUserProfileCellNodeFactory: PostUserProfileCellNode.Factory
    let postCommentProfileCellNodeFactory: PostCommentProfileCellNode.Factory
  }

  // MARK: Constants

  // MARK: Properties

  var disposeBag = DisposeBag()

  let postListViewCellNodeFactory: PostListViewCellNode.Factory
  let postUserProfileCellNodeFactory: PostUserProfileCellNode.Factory
  let postCommentProfileCellNodeFactory: PostCommentProfileCellNode.Factory

  // MARK: Node

  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    defer { reactor = dependency.reactor }
    postListViewCellNodeFactory = dependency.postListViewCellNodeFactory
    postUserProfileCellNodeFactory = dependency.postUserProfileCellNodeFactory
    postCommentProfileCellNodeFactory = dependency.postCommentProfileCellNodeFactory

    super.init()

    dataSource = self
    supplementaryViewSource = self
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

    let user = UserViewModel(
      userID: id,
      profileUrl: "https://image.rocketpunch.com/company/24697/tryusncompany_logo_1559628600.png?s=100x100&t=inside",
      nickname: "bongzniak"
    )
    let comment1 = CommentViewModel(
      userID: "1: \(id)",
      userNickname: "bongzniak-1",
      commentID: "\(id)1",
      contents: "contents",
      datetime: "Today"
    )
    let comment2 = CommentViewModel(
      userID: "2: \(id)",
      userNickname: "bongzniak-2",
      commentID: "\(id)2",
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
    if let user = viewModels[index] as? UserViewModel {
      return postUserProfileCellNodeFactory.create(payload: .init(user: user))
    }
    if let comment = viewModels[index] as? CommentViewModel {
      return postCommentProfileCellNodeFactory.create(payload: .init(comment: comment))
    }

    return ASCellNode()
  }
}

// MARK: - ListSupplementaryViewSource

extension PostListBindingSectionController: ListSupplementaryViewSource,
  ASSupplementaryNodeSource {

  func supportedElementKinds() -> [String] {
    [UICollectionView.elementKindSectionHeader]
  }

  func viewForSupplementaryElement(
    ofKind elementKind: String,
    at index: Int
  ) -> UICollectionReusableView {
    ASIGListSupplementaryViewSourceMethods.viewForSupplementaryElement(
      ofKind: elementKind,
      at: index,
      sectionController: self
    )
  }

  func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
    ASIGListSupplementaryViewSourceMethods.sizeForSupplementaryView(
      ofKind: elementKind,
      at: index
    )
  }

  func nodeBlockForSupplementaryElement(
    ofKind elementKind: String,
    at index: Int
  ) -> ASCellNodeBlock {
    { [weak self] in
      guard let `self` = self else {
        return ASCellNode()
      }

      return self.nodeForSupplementaryElement(ofKind: elementKind, at: index)
    }
  }

  func nodeForSupplementaryElement(ofKind kind: String, at index: Int) -> ASCellNode {
    guard var post = object
    else {
      return ASCellNode()
    }

    return ASCellNode()
  }
}
