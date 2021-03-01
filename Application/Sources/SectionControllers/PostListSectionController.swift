//
//  PostListSectionController.swift
//  Application
//
//  Created by bongzniak on 2021/02/28.
//
//

import Foundation
import UIKit

import Pure
import ReactorKit
import AsyncDisplayKit
import RxSwift
import RxCocoa_Texture
import URLNavigator

final class PostListSectionController: BaseASListSectionController<Post>, FactoryModule, View {

  typealias Node = PostListSectionController
  typealias Reactor = PostListSectionReactor

  // MARK: Dependency

  struct Dependency {
    let postListViewCellNodeFactory: PostListViewCellNode.Factory
  }

  // MARK: Constants

  // MARK: Properties

  let postListViewCellNodeFactory: PostListViewCellNode.Factory

  // MARK: Node

  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    postListViewCellNodeFactory = dependency.postListViewCellNodeFactory

    super.init()

    supplementaryViewSource = self
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Configuring

  func bind(reactor: PostListSectionReactor) {
  }

  // MARK: ASSectionController

  override func nodeForItem(at index: Int) -> ASCellNode {
    guard let post = object, post is Post
    else {
      return ASCellNode()
    }

    return postListViewCellNodeFactory.create(payload: .init(post: post))
  }
}

// MARK: - ListSupplementaryViewSource

extension PostListSectionController: ListSupplementaryViewSource, ASSupplementaryNodeSource {

  func supportedElementKinds() -> [String] {
    [UICollectionView.elementKindSectionHeader, UICollectionView.elementKindSectionFooter]
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

    post.contents = "asdasdasdasdasd"
    return postListViewCellNodeFactory.create(payload: .init(post: post))
  }
}
