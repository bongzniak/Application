//
// Created by bongzniak on 2021/02/28.
//

import UIKit
import RxSwift
import RxIGListKit
import IGListKit

enum JournalListSection {
  case post(Beer)
}

extension JournalListSection: SectionModelType {
  typealias ObjectType = ListDiffable
  var object: ListDiffable {
    switch self {
    case .post(let post):
      return post
    }
  }
}
