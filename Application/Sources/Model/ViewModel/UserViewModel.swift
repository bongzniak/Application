//
// Created by bongzniak on 2021/03/01.
//

import Foundation

class UserViewModel: NSObject {

  var id: String
  var nickname: String
  var profileUrl: String
  var datetime: String

  init(id: String, nickname: String, profileUrl: String, datetime: String) {
    self.id = id
    self.nickname = nickname
    self.profileUrl = profileUrl
    self.datetime = datetime
  }
}
