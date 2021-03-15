//
// Created by bongzniak on 2021/03/09.
//

import Foundation

// swiftlint:disable line_length
struct EntryLoader {
  static var beerKindCodes: GroupCode = GroupCode(
    groupCodeType: .beerKind,
    codes: [
      Code(
        id: "001",
        text: "Pale Ale",
        information: "대체로 밝은 색상의 띄며 구운맥아를 사용해 쌉싸름한 맛이 난다는 점이 특징",
        imageURLString: "https://beer-journal-s3.s3.ap-northeast-2.amazonaws.com/image/code/beerGlass/pint_glass.png",
        order: 0
      ),
      Code(
        id: "002",
        text: "IPA",
        information: "홉의 쌉쌀한 풍미가 가득한 인디아페일에일은 구수하면서도 진한 씁쓸함이 일품",
        imageURLString: "https://beer-journal-s3.s3.ap-northeast-2.amazonaws.com/image/code/beerGlass/pint_glass.png",
        order: 0
      ),
      Code(
        id: "003",
        text: "Weizen",
        information: "부한 과일향과 풍성한 거품이 특징인 바이젠은 가벼운 맛으로 부담없이 즐길 수 있는 맥주",
        imageURLString: "https://beer-journal-s3.s3.ap-northeast-2.amazonaws.com/image/code/beerGlass/pint_glass.png",
        order: 0
      ),
      Code(
        id: "004",
        text: "Stout",
        information: "탄 맛이 나는 짙은 갈색의 맥주, 씁쓸하면서 맥주 본연의 맛을 느끼고 싶을 때 제격",
        imageURLString: "https://beer-journal-s3.s3.ap-northeast-2.amazonaws.com/image/code/beerGlass/pint_glass.png",
        order: 0
      ),
      Code(
        id: "005",
        text: "Pilsner",
        information: "톡 쏘는 맛과 함께 잡미가 없는 깔끔한 맛이 진수",
        imageURLString: "https://beer-journal-s3.s3.ap-northeast-2.amazonaws.com/image/code/beerGlass/pint_glass.png",
        order: 0
      ),
      Code(
        id: "006",
        text: "Dunkel",
        information: "떫은 맛이 강한 맥아를 사용하여 검은 빛깔을 띄며 양조혼합물을 여러 번 우려내어서 진한 농도의 맛을 느낄 수 있는 맥주",
        imageURLString: "https://beer-journal-s3.s3.ap-northeast-2.amazonaws.com/image/code/beerGlass/pint_glass.png",
        order: 0
      ),
      Code(
        id: "007",
        text: "Pale Larger",
        information: "은 노란색을 띄며 홉의 쌉쌀함이나 향을 최대한 줄이고 입안에서 맛이 빠르게 사라지는 라이트 바디가 특징",
        imageURLString: "https://beer-journal-s3.s3.ap-northeast-2.amazonaws.com/image/code/beerGlass/pint_glass.png",
        order: 0
      )
    ]
  )
  static var beerTypeCodes: GroupCode = GroupCode(
    groupCodeType: .beerType,
    codes: [
      Code(
        id: "001",
        text: "Draft",
        information: "",
        imageURLString: "https://beer-journal-s3.s3.ap-northeast-2.amazonaws.com/image/code/beerType/can.png",
        order: 0
      ),
      Code(
        id: "002",
        text: "Bottle",
        information: "",
        imageURLString: "https://beer-journal-s3.s3.ap-northeast-2.amazonaws.com/image/code/beerType/can.png",
        order: 0
      ),
      Code(
        id: "003",
        text: "Can",
        information: "",
        imageURLString: "https://beer-journal-s3.s3.ap-northeast-2.amazonaws.com/image/code/beerType/can.png",
        order: 0
      )
    ]
  )
  static var beerGlassCodes: GroupCode = GroupCode(
    groupCodeType: .beerGlass,
    codes: [
      Code(
        id: "001",
        text: "Pint Glass",
        information: "플레이그라운드 브루어리의 탭하우스에서 다양한 맥주들을 소화할 수 있도록 사용되는 잔",
        imageURLString: "https://beer-journal-s3.s3.ap-northeast-2.amazonaws.com/image/code/beerGlass/pint_glass.png",
        order: 0
      ),
      Code(
        id: "002",
        text: "Tulip Glass",
        information: "밑에서 위로 올라갈수록 좁아지는 모양은 맥주의 향을 잡아주는 역할을 한다.",
        imageURLString: "https://beer-journal-s3.s3.ap-northeast-2.amazonaws.com/image/code/beerGlass/pint_glass.png",
        order: 1
      ),
      Code(
        id: "003",
        text: "Snifter Glass",
        information: "스니프터 글라스는 일반적으로 꼬냑이나 브랜디 등 도수가 높은 주류를 즐길 때 사용하는 경우가 많다",
        imageURLString: "https://beer-journal-s3.s3.ap-northeast-2.amazonaws.com/image/code/beerGlass/pint_glass.png",
        order: 1
      ),
      Code(
        id: "004",
        text: "Pilsner Glass",
        information: "필스너 스타일의 맥주를 마시기 위해 만들어진 잔으로 곡선 없이 직선으로 이루어져 있으며 아래에서 위로 갈수록 좁아지는 형태를 하고 있다.",
        imageURLString: "https://beer-journal-s3.s3.ap-northeast-2.amazonaws.com/image/code/beerGlass/pint_glass.png",
        order: 1
      ),
      Code(
        id: "005",
        text: "Weizen Glass",
        information: "밑은 가늘지만 거품이 모이는 위쪽은 볼록하여 향을 모으는 역할을 해주기 때문에 밀맥주 특유의 효모와 밀의 풍부한 향을 즐길 수 있게 도와준다.",
        imageURLString: "https://beer-journal-s3.s3.ap-northeast-2.amazonaws.com/image/code/beerGlass/pint_glass.png",
        order: 1
      ),
      Code(
        id: "006",
        text: "Weizen Glass",
        information: "밑은 가늘지만 거품이 모이는 위쪽은 볼록하여 향을 모으는 역할을 해주기 때문에 밀맥주 특유의 효모와 밀의 풍부한 향을 즐길 수 있게 도와준다.",
        imageURLString: "https://beer-journal-s3.s3.ap-northeast-2.amazonaws.com/image/code/beerGlass/pint_glass.png",
        order: 1
      )
    ]
  )
  static var nationCodes: GroupCode = GroupCode(
    groupCodeType: .beerGlass,
    codes: [
      Code(
        id: "KR",
        text: "한국",
        information: "",
        imageURLString: "https://beer-journal-s3.s3.ap-northeast-2.amazonaws.com/image/code/nation/south-korea.png",
        order: 1
      ),
      Code(
        id: "US",
        text: "미국",
        information: "",
        imageURLString: "https://beer-journal-s3.s3.ap-northeast-2.amazonaws.com/image/code/nation/united-states.png",
        order: 1
      )
    ]
  )

  static var beers: [Beer] = []

  static func getRandomBeerKindCode() -> Code {
    EntryLoader.beerKindCodes.codes.randomElement()!
  }

  static func getRandomBeerTypeCode() -> Code {
    EntryLoader.beerTypeCodes.codes.randomElement()!
  }

  static func getRandomBeerGlassCode() -> Code {
    EntryLoader.beerGlassCodes.codes.randomElement()!
  }

  static func getRandomNationCode() -> Code {
    EntryLoader.nationCodes.codes.randomElement()!
  }

  static func loadLatest() {
    for index in 0...30 {
      let beer = Beer(id: "\(index)")
      EntryLoader.beers.append(beer)
    }
  }
}

// swiftlint:enable line_length
