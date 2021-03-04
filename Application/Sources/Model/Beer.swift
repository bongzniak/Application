//
// Created by bongzniak on 2021/02/22.
//

import Foundation

class Beer: NSObject, ModelType {
  enum Event {
    case updateLiked(id: Int, isLiked: Bool)
    case increaseLikeCount(id: Int)
    case decreaseLikeCount(id: Int)
  }

  init(
    id: String,
    user: User,
    images: [String],
    name: String,
    kind: Code,
    type: Code,
    abv: Float,
    glass: Code,
    opinion: String,
    commentCount: Int = 0,
    likeCount: Int = 0
  ) {
    self.id = id
    self.user = user
    self.images = images
    self.name = name
    self.kind = kind
    self.type = type
    self.abv = abv
    self.glass = glass
    self.opinion = opinion
    self.commentCount = commentCount
    self.likeCount = likeCount
  }

  var id: String
  var user: User

  var images: [String]
  var name: String
  var kind: Code
  var type: Code
  var abv: Float
  var glass: Code

  var producer: String?
  var country: Code?

  var nose: String?
  var taste: String?
  var opinion: String?
  var rating: Float?

  var commentCount: Int = 0
  var likeCount: Int = 0
  var viewCount: Int = 0

  var createdAt: Date?

  enum CodingKeys: String, CodingKey {
    case id
    case user
    case images
    case name
    case kind
    case type
    case abv
    case glass
    case producer
    case country
    case nose
    case taste
    case opinion
    case rating
    case commentCount
    case likeCount
    case viewCount
    case createdAt
  }
}
