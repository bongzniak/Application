//
// Created by bongzniak on 2021/03/04.
//

import Foundation

import Alamofire
import RxSwift

protocol CommonServiceType {
  func codes(groupCode: GroupCodeType) -> Single<[Code]>
}

final class CommonService: CommonServiceType {

  private let networking: Networking

  init(networking: Networking) {
    self.networking = networking
  }

  func codes(groupCode: GroupCodeType) -> Single<[Code]> {

    switch groupCode {
    case .beerKind:
      return .just(EntryLoader.beerKindCodes.codes)
    case .beerType:
      return .just(EntryLoader.beerTypeCodes.codes)
    case .beerGlass:
      return .just(EntryLoader.beerGlassCodes.codes)
    case .nation:
      return .just(EntryLoader.nationCodes.codes)
    }
  }
}
