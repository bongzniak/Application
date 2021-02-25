//
//  AuthService.swift
//  MyApp
//
//  Created by bongzniak on 2020/12/24.
//

import SafariServices
import URLNavigator

import Alamofire
import RxSwift
import KeychainAccess

protocol AuthServiceType {
  var currentAccessToken: AccessToken? { get }

  // Start OAuth authorization process.
  //
  // - returns: An Observable of `AccessToken` instance.

  func facebookAuthority(accessToken: String) -> Single<AccessToken>

  func logout()
}

final class AuthService: AuthServiceType {

  fileprivate let keychain = Keychain(service: "com.bongzniak.application")
  private(set) var currentAccessToken: AccessToken?
  private let networking: Networking

  init(networking: Networking) {
    self.networking = networking
    currentAccessToken = loadAccessToken()
    log.debug("currentAccessToken exists: \(currentAccessToken != nil)")
  }

  func facebookAuthority(accessToken: String) -> Single<AccessToken> {
    networking.request(AuthAPI.facebookAuthority(accessToken: accessToken))
      .map(AccessToken.self)
      .do(onSuccess: { [weak self] accessToken in
        self?.currentAccessToken = accessToken
      })
  }

  func logout() {
    currentAccessToken = nil
    deleteAccessToken()
  }

  fileprivate func saveAccessToken(_ accessToken: AccessToken) throws {
    try keychain.set(accessToken.accessToken, key: "access_token")
    try keychain.set(accessToken.refreshToken, key: "refresh_token")
    try keychain.set(accessToken.tokenType, key: "token_type")
  }

  fileprivate func loadAccessToken() -> AccessToken? {
    guard let accessToken = keychain["access_token"],
      let refreshToken = keychain["refresh_token"],
      let tokenType = keychain["token_type"] else { return nil }

    return AccessToken(accessToken: accessToken, refreshToken: refreshToken, tokenType: tokenType)
  }

  fileprivate func deleteAccessToken() {
    try? keychain.remove("access_token")
    try? keychain.remove("refresh_token")
    try? keychain.remove("token_type")
  }
}
