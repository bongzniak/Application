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

  init(
    id: String,
    user: User,
    images: [String],
    title: String,
    contents: String,
    commentCount: Int = 0,
    likeCount: Int = 0
  ) {
    self.id = id
    self.user = user
    self.images = images
    self.title = title
    self.contents = contents
    self.commentCount = commentCount
    self.likeCount = likeCount
  }

  var id: String
  var user: User
  var images: [String]
  var title: String
  var contents: String

  var commentCount: Int = 0
  var likeCount: Int = 0
  var viewCount: Int = 0

  var createdAt: Date?

  enum CodingKeys: String, CodingKey {
    case id
    case user
    case images
    case title
    case contents
    case commentCount
    case likeCount
    case viewCount
    case createdAt
  }
}
