//
//  Created by bongzniak on 2021/02/19.
//

import AsyncDisplayKit
import IGListKit

class BaseASListSectionController<T>: ListSectionController, ASSectionController {

  // MARK: - ListSectionController

  var object: T?

  override init() {
    super.init()
  }

  override func didUpdate(to object: Any) {
    if let object = object as? T {
      self.object = object
    }
  }

  override func cellForItem(at index: Int) -> UICollectionViewCell {
    ASIGListSectionControllerMethods.cellForItem(at: index, sectionController: self)
  }

  override func sizeForItem(at index: Int) -> CGSize {
    ASIGListSectionControllerMethods.sizeForItem(at: index)
  }

  // MARK: - ASSectionController

  func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
//    fatalError(" Must implements this Method ")
    { [weak self] in
      guard let `self` = self else {
        return ASCellNode()
      }

      return self.nodeForItem(at: index)
    }
  }

  func nodeForItem(at index: Int) -> ASCellNode {
    fatalError(" Must implements this Method ")
  }
}
