//
// Created by bongzniak on 2021/03/15.
//

import RxIGListKit
import IGListKit

enum CommonListSection {
  case codeListCell(Code)
}

extension CommonListSection: SectionModelType {
  typealias ObjectType = ListDiffable
  var object: ListDiffable {
    switch self {
    case let .codeListCell(code):
      return code
    }
  }
}
