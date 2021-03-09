//
// Created by bongzniak on 2021/02/22.
//

import Foundation

class Beer: NSObject, ModelType {
  enum Event {
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

  init(id: String) {

    // swiftlint:disable line_length
    let userData = User(
      id: "1",
      nickname: "bognzniak",
      profileUrl: "http://img.khan.co.kr/news/2016/07/19/l_2016072001002644100209491.jpg"
    )

    let imagesData: [String] = [
      "https://postfiles.pstatic.net/20160630_75/reviewtouch_1467267169422Ekhou_JPEG/%B8%C6%C1%D6%C1%BE%B7%F9_%2817%29.jpg?type=w966",
      "https://postfiles.pstatic.net/20160630_164/reviewtouch_1467267169641JFLnM_JPEG/%B8%C6%C1%D6%C1%BE%B7%F9_%2811%29.jpg?type=w966",
      "https://postfiles.pstatic.net/20160630_284/reviewtouch_1467267169973uYitn_JPEG/%B8%C6%C1%D6%C1%BE%B7%F9_%2827%29.jpg?type=w966",
      "https://postfiles.pstatic.net/20160630_3/reviewtouch_1467267170139p4jwx_JPEG/%B8%C6%C1%D6%C1%BE%B7%F9_%2815%29.jpg?type=w966",
      "https://postfiles.pstatic.net/20160630_187/reviewtouch_1467267170397aY24E_JPEG/%B8%C6%C1%D6%C1%BE%B7%F9_%2841%29.jpg?type=w966",
      "https://postfiles.pstatic.net/20160630_141/reviewtouch_1467267170561xtEM6_JPEG/%B8%C6%C1%D6%C1%BE%B7%F9_%2813%29.jpg?type=w966",
      "https://postfiles.pstatic.net/20160630_203/reviewtouch_1467267170733UssG1_JPEG/%B8%C6%C1%D6%C1%BE%B7%F9_%2830%29.jpg?type=w966"
    ]
    let namesData: [String] = [
      "밀러 제뉴인 드래프트",
      "프란치스카너 헤페바이스",
      "볼비어 라거",
      "보딩턴스 펍 에일",
      "웨팅어 헤페바이스",
      "스파텐 뮌헨",
      "스텔라 아르투아"
    ]

    let randomIndex = Int.random(in: 0...namesData.count-1)
    let randomRating = round(Float.random(in: 0.0...5.0) * 10.0) / 10.0
    let randomABU = round(Float.random(in: 3.0...9.5) * 10.0) / 10.0

    let beerKindCode = EntryLoader.getRandomBeerKindCode()
    let beerTypeCode = EntryLoader.getRandomBeerTypeCode()
    let nationCode = EntryLoader.getRandomNationCode()
    let beerGlassCode = EntryLoader.getRandomBeerGlassCode()

    self.id = id
    user = userData
    images = [imagesData[randomIndex]]
    name = namesData[randomIndex]
    kind = beerKindCode
    type = beerTypeCode
    nation = nationCode
    abv = randomABU
    glass = beerGlassCode
    let contents =
      """
      건조하지만 마시고 나면 입에 단내가 강하게 남는다. 이런 점에서는 필리핀의 산 미겔이나 이탈리아의 페로니와 비슷한 면이 있다.
      """
    apperance = "apperance - \(contents)"
    nose = "nose - \(contents)"
    taste = "taste - \(contents)"
    opinion = "opinion - \(contents)"
    rating = randomRating
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
