//
// Created by bongzniak on 2021/03/03.
//

import Foundation
import UIKit

import Pure
import ReactorKit
import AsyncDisplayKit
import IGListKit
import RxSwift
import RxCocoa_Texture

class BaseListBindingSectionController: ListBindingSectionController<ListDiffable> {

  override init() {
    super.init()

    dataSource = self
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - ListBindingSectionControllerDataSource, ASSectionController

extension BaseListBindingSectionController: ListBindingSectionControllerDataSource,
  ASSectionController {

  func sectionController(
    _ sectionController: ListBindingSectionController<ListDiffable>,
    viewModelsFor object: Any
  ) -> [ListDiffable] {
    fatalError("Must Override: sectionController(:viewModelsFor:)")
  }

  func sectionController(
    _ sectionController: ListBindingSectionController<ListDiffable>,
    cellForViewModel viewModel: Any, at index: Int
  ) -> UICollectionViewCell & ListBindable {
    ASIGListSectionControllerMethods.cellForItem(
      at: index,
      sectionController: self
    ) as! UICollectionViewCell & ListBindable
  }

  func sectionController(
    _ sectionController: ListBindingSectionController<ListDiffable>,
    sizeForViewModel viewModel: Any, at index: Int
  ) -> CGSize {
    ASIGListSectionControllerMethods.sizeForItem(at: index)
  }

  func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
    { [weak self] in
      guard let `self` = self
      else {
        return ASCellNode()
      }

      return self.nodeForItem(at: index)
    }
  }

  func nodeForItem(at index: Int) -> ASCellNode {
    fatalError("Must Override: nodeForItem(at:)")
  }
}


// MARK: - ListSupplementaryViewSource

extension BaseListBindingSectionController: ListSupplementaryViewSource,
  ASSupplementaryNodeSource {

  func supportedElementKinds() -> [String] {
    fatalError("Must override: supportedElementKinds()")
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
      guard let `self` = self
      else {
        return ASCellNode()
      }

      return self.nodeForSupplementaryElement(ofKind: elementKind, at: index)
    }
  }

  func nodeForSupplementaryElement(ofKind kind: String, at index: Int) -> ASCellNode {
    fatalError("Must override: nodeForSupplementaryElement(ofKind:at:)")
  }
}
