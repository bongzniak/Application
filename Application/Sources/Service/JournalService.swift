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
    EntryLoader.loadLatest()
    return .just(EntryLoader.beers)
  }

  func journal(id: String) -> Single<Beer> {
    if let beer = EntryLoader.beers.filter({ $0.id == id }).first {
      return .just(beer)
    }
    return .just(Beer(id: "999999"))
  }
}
