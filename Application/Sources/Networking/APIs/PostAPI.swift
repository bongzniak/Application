//
// Created by bongzniak on 2021/02/22.
//

import MoyaSugar

enum PostAPI {
  case posts(page: Int, size: Int)
}

extension PostAPI: SugarTargetType {
  var baseURL: URL {
    URL(string: "http://localhost:8080/api/")!
  }

  var route: Route {
    switch self {
    case .posts:
      return .get("posts")
    }
  }

  var parameters: Parameters? {
    switch self {
    case let .posts(page, size):
      return ["page": page, "size": size]
    }
  }

  var headers: [String: String]? {
    nil
  }

  var sampleData: Data {
    Data()
  }
}
