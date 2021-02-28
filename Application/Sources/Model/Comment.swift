//
// Created by bongzniak on 2021/02/28.
//

import Foundation

class Comment: NSObject, ModelType {
  enum Event {
  }

  var id: String
  var user: User
  var contents: String
  var likeCount: Int
  var isLiked: Bool = false
  var createdAt: Date

  enum CodingKeys: String, CodingKey {
    case id
    case user
    case contents
    case likeCount
    case isLiked
    case createdAt
  }
}
