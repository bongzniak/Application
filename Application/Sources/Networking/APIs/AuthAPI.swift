import MoyaSugar

protocol AuthAPI: SugarTargetType, Hashable {
}

extension AuthAPI {
  var baseURL: URL {
    URL(string: "http://52.78.145.107")!
  }

  var headers: [String: String]? {
    nil
  }

  var sampleData: Data {
    Data()
  }
}
