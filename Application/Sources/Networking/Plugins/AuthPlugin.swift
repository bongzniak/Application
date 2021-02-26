//
//  AuthPlugin.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 09/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Moya

struct AuthPlugin: PluginType {

  typealias RootViewFactory = (UIWindow, LoginViewController) -> Void

  fileprivate let authService: AuthServiceType

  init(authService: AuthServiceType) {
    self.authService = authService
  }

  func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
    var request = request
    if let accessToken = authService.currentAccessToken?.tokenTypeAndAccessToken {
      request.addValue(accessToken, forHTTPHeaderField: "Authorization")
    }
    return request
  }

  func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
    // 403 에러 발생 시 refresh_token을 사용하여
  }
}
