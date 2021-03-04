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

final class JournalListSectionController: BaseASListSectionController<Beer>, FactoryModule, View {

  typealias Node = JournalListSectionController
  typealias Reactor = JournalListSectionReactor

  // MARK: Dependency

  struct Dependency {
    let journalListViewCellNodeFactory: JournalListViewCellNode.Factory
  }

  // MARK: Constants

  // MARK: Properties

  let dependency: Dependency

  // MARK: Node

  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    self.dependency = Dependency(
      journalListViewCellNodeFactory: dependency.journalListViewCellNodeFactory
    )

    super.init()

    supplementaryViewSource = self
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Configuring

  func bind(reactor: JournalListSectionReactor) {
  }

  // MARK: ASSectionController

  override func nodeForItem(at index: Int) -> ASCellNode {
    guard let post = object, post is Beer
    else {
      return ASCellNode()
    }

    return dependency.journalListViewCellNodeFactory.create(payload: .init(beer: post))
  }
}

// MARK: - ListSupplementaryViewSource

extension JournalListSectionController: ListSupplementaryViewSource, ASSupplementaryNodeSource {

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

    post.opinion = "asdasdasdasdasd"
    return dependency.journalListViewCellNodeFactory.create(payload: .init(beer: post))
  }
}
