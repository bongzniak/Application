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

  var id: String
  var user: User

  var images: [String]
  var name: String
  var kind: Code
  var type: Code
  var nation: Code
  var abv: Float
  var glass: Code
  var rating: Float?

  var producer: String?
  var country: Code?

  var apperance: String?
  var nose: String?
  var taste: String?
  var opinion: String?

  var commentCount: Int = 0
  var likeCount: Int = 0
  var viewCount: Int = 0

  var createdAt: Date?

  override init() {

    // swiftlint:disable line_length
    let userData = User(
      id: "1",
      nickname: "bognzniak",
      profileUrl: "http://img.khan.co.kr/news/2016/07/19/l_2016072001002644100209491.jpg"
    )
    let imagesData: [String] = [
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLWofy6RiEc6st6AEkSuhxGt1-eZhEDzmifw&usqp=CAU",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLWofy6RiEc6st6AEkSuhxGt1-eZhEDzmifw&usqp=CAU",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLWofy6RiEc6st6AEkSuhxGt1-eZhEDzmifw&usqp=CAU"
    ]
    let beerKindCode = Code(
      id: "1",
      text: "벨기에 필스너",
      information: "독일이나 체코의 필스너와 달리 약간 드라이하고 쌉쌀하면서도 가벼운 산미가 있는 것이 특징이다.",
      imageURLString: "",
      order: 1
    )
    let beerTypeCode = Code(
      id: "1",
      text: "Draft",
      information: "",
      imageURLString: "https://cdn1.iconfinder.com/data/icons/minimal-brewery/256/minimal_brewery_3-256.png",
      order: 1
    )
    let nationCode = Code(
      id: "1",
      text: "미국",
      information: "",
      imageURLString: "https://emojigraph.org/media/apple/flag-united-states_1f1fa-1f1f8.png",
      order: 1
    )
    let beerGlassCode = Code(
      id: "1",
      text: "Draft",
      information: "",
      imageURLString: "https://findicons.com/files/icons/2770/ios_7_icons/128/beer_glass.png",
      order: 1
    )
    id = "1"
    user = userData
    images = imagesData
    name = "스텔라 아르투아"
    kind = beerKindCode
    type = beerTypeCode
    nation = nationCode
    abv = 4.2
    glass = beerGlassCode
    let contents =
      """
      건조하지만 마시고 나면 입에 단내가 강하게 남는다. 이런 점에서는 필리핀의 산 미겔이나 이탈리아의 페로니와 비슷한 면이 있다.
      """
    apperance = "apperance - \(contents)"
    nose = "nose - \(contents)"
    taste = "taste - \(contents)"
    opinion = "opinion - \(contents)"
    rating = 3.5
    commentCount = 1
    likeCount = 2
    // swiftlint:enable line_length
  }

  enum CodingKeys: String, CodingKey {
    case id
    case user
    case images
    case name
    case kind
    case type
    case nation
    case abv
    case glass
    case producer
    case country
    case apperance
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
