//
// Created by bongzniak on 2021/03/02.
//

import Foundation

import AsyncDisplayKit

class BaseASTextNode: ASTextNode {

  override init() {
    super.init()
    style.shrink(1.f)
  }
}
