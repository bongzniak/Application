//
// Created by bongzniak on 2021/03/04.
//

import Foundation

import MoyaSugar

enum CommonAPI {
  case code(groupCode: GroupCode)
}

extension CommonAPI: SugarTargetType {
  var baseURL: URL {
    URL(string: "http://localhost:8080/api/common")!
  }

  var route: Route {
    switch self {
    case .code:
      return .get("codes")
    }
  }

  var parameters: Parameters? {
    switch self {
    case let .code(groupCode):
      return ["groupCode": groupCode]
    default:
      return [:]
    }
  }

  var headers: [String: String]? {
    nil
  }

  var sampleData: Data {
    Data()
  }
}
