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

  var id: String
  var images: [String]
  var contents: String
  var user: User

  var viewCount: Int
  var commentCount: Int

  var isLiked: Bool = false
  var createdAt: Date

  enum CodingKeys: String, CodingKey {
    case id
    case images
    case contents
    case user
    case viewCount
    case commentCount
    case isLiked
    case createdAt
  }
}
