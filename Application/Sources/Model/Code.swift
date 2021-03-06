//
// Created by bongzniak on 2021/03/04.
//

import Foundation

enum GroupCode: String {
  case beerKind = "BEER-KIND"
  case beerType = "BEER-TYPE"
  case beerGlass = "BEER-GLASS"
  case country = "COUNTRY"
}

class Code: NSObject, ModelType {
  enum Event {
  }

  var id: String
  var text: String
  var information: String
  var imageURLString: String
  var order: Int

  init(id: String, text: String, information: String, imageURLString: String, order: Int) {
    self.id = id
    self.text = text
    self.information = information
    self.imageURLString = imageURLString
    self.order = order
  }

  enum CodingKeys: String, CodingKey {
    case id
    case text
    case information
    case imageURLString = "imageURL"
    case order
  }
}
