//
// Created by bongzniak on 2021/02/28.
//

import Foundation

import Alamofire
import RxSwift

protocol JournalServiceType {
  func journals(page: Int, size: Int) -> Single<[Beer]>
  func journal(id: String) -> Single<Beer>
}

final class JournalService: JournalServiceType {

  private let networking: Networking

  init(networking: Networking) {
    self.networking = networking
  }

  func journals(page: Int, size: Int) -> Single<[Beer]> {
//    networking.request(PostAPI.posts(page: page, size: size)).map([Post].self)

    let posts: [Beer] = [Beer(), Beer(), Beer(), Beer(), Beer()]
    return .just(posts)
  }

  func journal(id: String) -> Single<Beer> {
    .just(Beer())
  }
}
