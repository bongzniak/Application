//
// Created by bongzniak on 2021/03/04.
//

import Foundation

enum GroupCodeType: String {
  case beerKind = "BEER-KIND"
  case beerType = "BEER-TYPE"
  case beerGlass = "BEER-GLASS"
  case nation = "NATION"
}

class GroupCode {
  var groupCode: GroupCodeType
  var codes: [Code] = []

  init(groupCode: GroupCodeType, codes: [Code]) {
    self.groupCode = groupCode
    self.codes = codes
  }
}

class Code: NSObject, ModelType {
  enum Event {
    case selectedCode(groupCode: GroupCodeType, code: Code)
  }

  var id: String
  var text: String
  var information: String
  var imageURLString: String
  var selectedImageURLString: String
  var order: Int

  init(
    id: String,
    text: String,
    information: String,
    imageURLString: String,
    selectedImageURLString: String = "",
    order: Int
  ) {
    self.id = id
    self.text = text
    self.information = information
    self.imageURLString = imageURLString
    self.selectedImageURLString = selectedImageURLString
    self.order = order
  }

  enum CodingKeys: String, CodingKey {
    case id
    case text
    case information
    case imageURLString = "imageURL"
    case selectedImageURLString = "selectecImageURL"
    case order
  }
}
