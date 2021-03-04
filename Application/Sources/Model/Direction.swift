//
// Created by bongzniak on 2021/03/04.
//

import Foundation

class Direction: NSObject, ModelType {
  enum Event{
  }

  var id: String
  var imageURL: String
  var note: String
  var tip: String
  var order: Int

  enum CodingKeys: String, CodingKey {
    case id
    case imageURL
    case note
    case tip
    case order
  }
}
