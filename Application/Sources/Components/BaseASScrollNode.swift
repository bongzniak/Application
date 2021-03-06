//
// Created by bongzniak on 2021/03/05.
//

import Foundation

import AsyncDisplayKit

class BaseASScrollNode: ASScrollNode {

  override init() {
    super.init()

    automaticallyManagesSubnodes = true
    automaticallyManagesContentSize = true
  }
}
