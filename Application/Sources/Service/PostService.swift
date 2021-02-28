//
// Created by bongzniak on 2021/02/28.
//

import Foundation

import Alamofire
import RxSwift

protocol PostServiceType {
  func posts(page: Int, size: Int) -> Single<[Post]>
}

final class PostService: PostServiceType {

  private let networking: Networking

  init(networking: Networking) {
    self.networking = networking
  }

  func posts(page: Int, size: Int) -> Single<[Post]> {
//    networking.request(PostAPI.posts(page: page, size: size)).map([Post].self)
    let posts: [Post] = [
      Post(id: "1", images: ["1"], contents: "111111"),
      Post(id: "2", images: ["2"], contents: "222222"),
      Post(id: "3", images: ["3"], contents: "333333"),
      Post(id: "4", images: ["4"], contents: "444444"),
      Post(id: "5", images: ["5"], contents: "555555")
    ]
    return .just(posts)
  }
}
