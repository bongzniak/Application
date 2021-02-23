//
//  AccessToken.swift
//  MyApp
//
//  Created by bongzniak on 2020/12/24.
//

import Foundation

struct AccessToken: ModelType {
  enum Event {
  }

  var accessToken: String
  var refreshToken: String
  var tokenType: String

  var tokenTypeAndAccessToken: String {
    tokenType + " " + accessToken
  }
  var tokenTypeAndRefreshToken: String {
    tokenType + " " + refreshToken
  }

  init(accessToken: String, refreshToken: String, tokenType: String) {
    self.accessToken = accessToken
    self.refreshToken = refreshToken
    self.tokenType = tokenType
  }

  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case refreshToken = "refresh_token"
    case tokenType = "token_type"
  }
}
