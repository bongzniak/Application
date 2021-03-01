//
// Created by bongzniak on 2021/03/02.
//

import UIKit

public extension NSMutableAttributedString {

  @discardableResult
  func append(attributeString: NSAttributedString) -> Self {
    append(attributeString)
    return self
  }
}
