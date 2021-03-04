//
// Created by bongzniak on 2021/02/28.
//

import Foundation

import Alamofire
import RxSwift

protocol JournalServiceType {
  func journals(page: Int, size: Int) -> Single<[Beer]>
}

final class JournalService: JournalServiceType {

  private let networking: Networking

  init(networking: Networking) {
    self.networking = networking
  }

  func journals(page: Int, size: Int) -> Single<[Beer]> {
//    networking.request(PostAPI.posts(page: page, size: size)).map([Post].self)
  let user = User(
    id: "1",
    nickname: "bognzniak",
    profileUrl: "http://img.khan.co.kr/news/2016/07/19/l_2016072001002644100209491.jpg"
  )
    let images: [String] = [
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
    let posts: [Beer] = [
      Beer(
        id: "1",
        user: user,
        images: images,
        name: "스텔라",
        kind: beerKindCode,
        type: beerTypeCode,
        abv: 4.2,
        glass: beerGlassCode,
        opinion:
        """
        건조하지만 마시고 나면 입에 단내가 강하게 남는다. 이런 점에서는 필리핀의 산 미겔이나 이탈리아의 페로니와 비슷한 면이 있다. 똑같이 옥수수가 들어가는 미국식 부가물 라거와 그 파생작들과는 비교할 수 없는 훌륭한 풍미를 가지고 있다는 점에서 꼭 옥수수가 들어간다는 것 자체가 나쁜 것은 아니라는 것을 보여주는 반례이기도 한데, 이 점도 산 미겔과 페로니 역시 비슷하다. 같은 재료라도 원가절감하려고 넣느냐 맛을 강조하려고 넣느냐의 차이다
        """,
        commentCount: 0,
        likeCount: 0
      ),
      Beer(
        id: "1",
        user: user,
        images: images,
        name: "스텔라",
        kind: beerKindCode,
        type: beerTypeCode,
        abv: 4.2,
        glass: beerGlassCode,
        opinion:
        """
        건조하지만 마시고 나면 입에 단내가 강하게 남는다. 이런 점에서는 필리핀의 산 미겔이나 이탈리아의 페로니와 비슷한 면이 있다. 똑같이 옥수수가 들어가는 미국식 부가물 라거와 그 파생작들과는 비교할 수 없는 훌륭한 풍미를 가지고 있다는 점에서 꼭 옥수수가 들어간다는 것 자체가 나쁜 것은 아니라는 것을 보여주는 반례이기도 한데, 이 점도 산 미겔과 페로니 역시 비슷하다. 같은 재료라도 원가절감하려고 넣느냐 맛을 강조하려고 넣느냐의 차이다
        """,
        commentCount: 0,
        likeCount: 0
      ),
      Beer(
        id: "1",
        user: user,
        images: images,
        name: "스텔라",
        kind: beerKindCode,
        type: beerTypeCode,
        abv: 4.2,
        glass: beerGlassCode,
        opinion:
        """
        건조하지만 마시고 나면 입에 단내가 강하게 남는다. 이런 점에서는 필리핀의 산 미겔이나 이탈리아의 페로니와 비슷한 면이 있다. 똑같이 옥수수가 들어가는 미국식 부가물 라거와 그 파생작들과는 비교할 수 없는 훌륭한 풍미를 가지고 있다는 점에서 꼭 옥수수가 들어간다는 것 자체가 나쁜 것은 아니라는 것을 보여주는 반례이기도 한데, 이 점도 산 미겔과 페로니 역시 비슷하다. 같은 재료라도 원가절감하려고 넣느냐 맛을 강조하려고 넣느냐의 차이다
        """,
        commentCount: 0,
        likeCount: 0
      )
    ]
    return .just(posts)
  }
}
