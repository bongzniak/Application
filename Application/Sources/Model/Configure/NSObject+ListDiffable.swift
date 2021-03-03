//
// Created by bongzniak on 2021/02/22.
//

import IGListKit

// MARK: - ListDiffable
extension NSObject: ListDiffable {
  public func diffIdentifier() -> NSObjectProtocol {
    self
  }

  public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    isEqual(object)
  }
}
