//
// Created by bongzniak on 2021/03/04.
//

import Foundation

import Alamofire
import RxSwift

protocol CommonServiceType {
  func codes(groupCode: GroupCode) -> Single<[Code]>
}

final class CommonService: CommonServiceType {

  private let networking: Networking

  init(networking: Networking) {
    self.networking = networking
  }

  func codes(groupCode: GroupCode) -> Single<[Code]> {
    networking.request(
      CommonAPI.code(groupCode: groupCode)
    ).map([Code].self)
  }
}
