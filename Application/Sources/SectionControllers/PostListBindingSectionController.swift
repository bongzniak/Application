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

final class PostListBindingSectionController: BaseListBindingSectionController,
  FactoryModule, View {

  typealias Node = PostListBindingSectionController
  typealias Reactor = PostListBindingSectionReactor

  // MARK: Dependency

  struct Dependency {
    let reactor: Reactor
    let postListViewCellNodeFactory: PostListViewCellNode.Factory
    let postUserProfileCellNodeFactory: UserProfileCellNode.Factory
    let postCommentProfileCellNodeFactory: CommentWithProfileCellNode.Factory
  }

  // MARK: Constants

  // MARK: Properties

  var disposeBag = DisposeBag()

  let dependency: Dependency

  // MARK: Node

  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    defer {
      reactor = dependency.reactor
    }

    self.dependency = Dependency(
      reactor: dependency.reactor,
      postListViewCellNodeFactory: dependency.postListViewCellNodeFactory,
      postUserProfileCellNodeFactory: dependency.postUserProfileCellNodeFactory,
      postCommentProfileCellNodeFactory: dependency.postCommentProfileCellNodeFactory
    )

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

extension PostListBindingSectionController {
  override func sectionController(
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

    var objects: [ListDiffable] = []
    // swiftlint:disable line_length
    let user = UserViewModel(
      userID: id,
      profileUrl: "https://image.rocketpunch.com/company/24697/tryusncompany_logo_1559628600.png?s=100x100&t=inside",
      nickname: "bongzniak"
    )
    // swiftlint:enable line_length
    objects.append(user)

    for index in 0...Int.random(in: 0...3) {
      objects.append(
        CommentViewModel(
          userID: "1: \(id)",
          userNickname: "bongzniak-\(index)",
          commentID: "\(id)1",
          contents: post.contents,
          datetime: "Now"
        )
      )
    }

    return objects
  }

  override func nodeForItem(at index: Int) -> ASCellNode {
    if let user = viewModels[index] as? UserViewModel {
      return dependency.postUserProfileCellNodeFactory.create(payload: .init(user: user))
    } else if let comment = viewModels[index] as? CommentViewModel {
      return dependency.postCommentProfileCellNodeFactory.create(payload: .init(comment: comment))
    }

    return ASCellNode()
  }
}

// MARK: - ListSupplementaryViewSource, ASSupplementaryNodeSource

extension PostListBindingSectionController {

  override func supportedElementKinds() -> [String] {
    [UICollectionView.elementKindSectionHeader]
  }

  override func nodeForSupplementaryElement(ofKind kind: String, at index: Int) -> ASCellNode {
    guard var _ = object
    else {
      return ASCellNode()
    }

    return ASCellNode()
  }
}
