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

final class PostListSectionController: BaseASListSectionController<Post> {

  typealias Node = PostListSectionController
  typealias Reactor = PostListSectionReactor

  // MARK: Dependency

  struct Dependency {
    let reactor: Reactor
  }

  // MARK: Constants

  // MARK: Properties

  // MARK: Node

  // MARK: Initializing

  override init() {
    super.init()
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Configuring

  // MARK: ASSectionController

  override func nodeForItem(at index: Int) -> ASCellNode {
    ASCellNode()
  }
}

// MARK: - ListSupplementaryViewSource

extension PostListSectionController: ListSupplementaryViewSource, ASSupplementaryNodeSource {

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
    ASIGListSupplementaryViewSourceMethods.sizeForSupplementaryView(ofKind: elementKind, at: index)
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
    ASCellNode()
  }
}
