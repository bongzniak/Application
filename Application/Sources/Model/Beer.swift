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

  override init() {

    // swiftlint:disable line_length
    let userData = User(
      id: "1",
      nickname: "bognzniak",
      profileUrl: "http://img.khan.co.kr/news/2016/07/19/l_2016072001002644100209491.jpg"
    )
    let imagesData: [String] = [
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLWofy6RiEc6st6AEkSuhxGt1-eZhEDzmifw&usqp=CAU"
    ]
    let beerKindCode = Code(
      id: "1",
      text: "벨기에 필스너",
      information: "독일이나 체코의 필스너와 달리 약간 드라이하고 쌉쌀하면서도 가벼운 산미가 있는 것이 특징이다.",
      imageURL: "",
      order: 1
    )
    let beerTypeCode = Code(
      id: "1",
      text: "Draft",
      information: "",
      imageURL: "https://cdn1.iconfinder.com/data/icons/minimal-brewery/256/minimal_brewery_3-256.png",
      order: 1
    )
    let beerGlassCode = Code(
      id: "1",
      text: "Draft",
      information: "",
      imageURL: "https://findicons.com/files/icons/2770/ios_7_icons/128/beer_glass.png",
      order: 1
    )
    id = "1"
    user = userData
    images = imagesData
    name = "스텔라 아르투아"
    kind = beerKindCode
    type = beerTypeCode
    abv = 4.2
    glass = beerGlassCode
    let contents =
      """
      건조하지만 마시고 나면 입에 단내가 강하게 남는다. 이런 점에서는 필리핀의 산 미겔이나 이탈리아의 페로니와 비슷한 면이 있다. 똑같이 옥수수가 들어가는 미국식 부가물 라거와 그 파생작들과는 비교할 수 없는 훌륭한 풍미를 가지고 있다는 점에서 꼭 옥수수가 들어간다는 것 자체가 나쁜 것은 아니라는 것을 보여주는 반례이기도 한데, 이 점도 산 미겔과 페로니 역시 비슷하다. 같은 재료라도 원가절감하려고 넣느냐 맛을 강조하려고 넣느냐의 차이다
      """
    nose = "nose - \(contents)"
    taste = "taste - \(contents)"
    opinion = "opinion - \(contents)"
    rating = 3.5
    commentCount = 1
    likeCount = 2
    // swiftlint:enable line_length
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
