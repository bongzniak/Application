//
// Created by bongzniak on 2021/02/22.
//

import Foundation

class User: NSObject, ModelType {
  enum Event {
  }

  var id: String
  var nickname: String
  var profileUrl: String

  init(id: String, nickname: String, profileUrl: String) {
    self.id = id
    self.nickname = nickname
    self.profileUrl = profileUrl
  }

  enum CodingKeys: String, CodingKey {
    case id
    case nickname
    case profileUrl
  }
}
