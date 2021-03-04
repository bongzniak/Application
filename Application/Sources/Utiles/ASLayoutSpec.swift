//
// Created by bongzniak on 2021/03/03.
//

import AsyncDisplayKit

extension ASLayoutSpec {
  @discardableResult
  func setFitWidth() -> ASLayoutSpec {
    style.width = ASDimension(unit: .fraction, value: 1.f)
    return self
  }
}
