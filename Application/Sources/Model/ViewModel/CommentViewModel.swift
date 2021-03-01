//
// Created by bongzniak on 2021/03/01.
//

import Foundation

class CommentViewModel: NSObject {

  var id: String
  var userID: String
  var userNickname: String
  var contents: String
  var datetime: String

  init(id: String, userID: String, userNickname: String, contents: String, datetime: String) {
    self.id = id
    self.userID = userID
    self.userNickname = userNickname
    self.contents = contents
    self.datetime = datetime
  }
}
