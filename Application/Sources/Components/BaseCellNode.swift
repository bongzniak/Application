//
// Created by bongzniak on 2021/02/21.
//

import RxSwift
import AsyncDisplayKit

class BaseCellNode: ASCellNode {

  var disposeBag = DisposeBag()

  override init() {
    super.init()

    selectionStyle = .none
    backgroundColor = .white
    automaticallyManagesSubnodes = true
  }
}
