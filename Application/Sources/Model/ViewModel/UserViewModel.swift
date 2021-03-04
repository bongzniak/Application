//
// Created by bongzniak on 2021/03/01.
//

import Foundation

class UserViewModel: NSObject {

  var userID: String
  var nickname: String
  var profileUrl: String

  init(userID: String, profileUrl: String, nickname: String) {
    self.userID = userID
    self.profileUrl = profileUrl
    self.nickname = nickname
  }
}
