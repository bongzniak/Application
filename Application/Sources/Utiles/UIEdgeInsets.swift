//
// Created by bongzniak on 2021/02/27.
//

import UIKit

extension UIEdgeInsets {
  init(verticalInset: CGFloat = 0.f, horizontalInset: CGFloat = 0.f) {
    self.init(
      top: verticalInset,
      left: horizontalInset,
      bottom: verticalInset,
      right: horizontalInset
    )
  }

  init(inset: CGFloat = 0.f) {
    self.init(
      top: inset,
      left: inset,
      bottom: inset,
      right: inset
    )
  }
}
