import MoyaSugar

enum AuthAPI {
  case facebookAuthority(token: String)
}

extension AuthAPI: SugarTargetType {
  var baseURL: URL {
    URL(string: "http://localhost:8081/api")!
  }

  var headers: [String: String]? {
    switch self {
    case let .facebookAuthority(token):
      return ["Authorization": token]
    }
  }

  var route: Route {
    switch self {
    case .facebookAuthority(_):
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
