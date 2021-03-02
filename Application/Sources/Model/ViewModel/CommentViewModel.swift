//
// Created by bongzniak on 2021/03/01.
//

import Foundation

class CommentViewModel: NSObject {

  var userID: String
  var userNickname: String

  var commentID: String
  var contents: String
  var datetime: String

  init(
    userID: String, userNickname: String, commentID: String, contents: String, datetime: String
  ) {
    self.userID = userID
    self.userNickname = userNickname

    self.commentID = commentID
    self.contents = contents
    self.datetime = datetime
  }
}
