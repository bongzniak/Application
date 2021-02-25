import MoyaSugar

enum AuthAPI {
  case facebookAuthority(accessToken: String)
}

extension AuthAPI: SugarTargetType {
  var baseURL: URL {
    URL(string: "http://52.78.145.107")!
  }

  var headers: [String: String]? {
    switch self {
    case let .facebookAuthority(accessToken):
      return ["Authorization": accessToken]
    }
  }

  var route: Route {
    switch self {
    case let .facebookAuthority(accessToken):
      return .get("/authority/facebook")
    }
  }

  var parameters: Parameters? {
    switch self {
    default:
      return nil
    }
  }

  var sampleData: Data {
    Data()
  }
}
