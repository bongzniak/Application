//
// Created by bongzniak on 2021/02/22.
//

import Foundation

class Post: NSObject, ModelType {
  enum Event {
    case updateLiked(id: Int, isLiked: Bool)
    case increaseLikeCount(id: Int)
    case decreaseLikeCount(id: Int)
  }

  init(id: String, images: [String], contents: String) {
    self.id = id
    self.images = images
    self.contents = contents
  }

  var id: String
  var user: User
  var images: [String]
  var contents: String

//  var comment: Comment
//  var commentCount: Int

//  var likeUser: User
  var likeCount: Int = 0

  var viewCount: Int = 0

  var isLiked: Bool = false
  var createdAt: Date?

  enum CodingKeys: String, CodingKey {
    case id
//    case user
    case images
    case contents
//    case comment
//    case commentCount
//    case likeUser
    case likeCount
    case viewCount
    case isLiked
    case createdAt
  }
}
