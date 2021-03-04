//
// Created by bongzniak on 2021/02/22.
//

import Foundation
import AsyncDisplayKit

extension ASLayoutElementStyle {

  @discardableResult
  func shrink(_ scale: CGFloat) -> ASLayoutElementStyle {
    flexShrink = scale
    return self
  }

  @discardableResult
  func nonShrink() -> ASLayoutElementStyle {
    flexShrink = 0.0
    return self
  }

  @discardableResult
  func grow(_ scale: CGFloat) -> ASLayoutElementStyle {
    flexGrow = scale
    return self
  }

  @discardableResult
  func nonGrow() -> ASLayoutElementStyle {
    flexGrow = 0.0
    return self
  }

  @discardableResult
  func shrinkAndGrow(_ scale: CGFloat) -> ASLayoutElementStyle {
    flexShrink = scale
    flexGrow = scale
    return self
  }
}
