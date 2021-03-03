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
  let user = User(
    id: "1",
    nickname: "bognzniak",
    profileUrl: "http://img.khan.co.kr/news/2016/07/19/l_2016072001002644100209491.jpg"
  )
    let images: [String] = [
      "http://img.khan.co.kr/news/2016/07/19/l_2016072001002644100209491.jpg",
      "http://img.khan.co.kr/news/2016/07/19/l_2016072001002644100209491.jpg",
      "http://img.khan.co.kr/news/2016/07/19/l_2016072001002644100209491.jpg",
      "http://img.khan.co.kr/news/2016/07/19/l_2016072001002644100209491.jpg",
      "http://img.khan.co.kr/news/2016/07/19/l_2016072001002644100209491.jpg"
    ]
    let posts: [Post] = [
      Post(
        id: "1",
        user: user,
        images: images,
        title:
        """
        얼마전 페북을 보다가,
        """,
        contents: "맛있어요 추천해요",
        commentCount: 1
      ),
      Post(
        id: "2",
        user: user,
        images: [],
        title:
        """
        얼마전 페북을 보다가, 라이브방송으로 쉑쉑버거를 만들고 있지 않겠음??
        """,
        contents: "맛있어요 추천해요",
        likeCount: 1
      ),
      Post(
        id: "3",
        user: user,
        images: images,
        title:
        """
        얼마전 페북을 보다가, 라이브방송으로 쉑쉑버거를 만들고 있지 않겠음??
        """,
        contents: "맛있어요 추천해요",
        commentCount: 1,
        likeCount: 1
      ),
      Post(
        id: "4",
        user: user,
        images: images,
        title:
        """
        얼마전 페북을 보다가,
        """,
        contents: "맛있어요 추천해요",
        commentCount: 1
      ),
      Post(
        id: "5",
        user: user,
        images: [],
        title:
        """
        얼마전 페북을 보다가, 라이브방송으로 쉑쉑버거를 만들고 있지 않겠음??
        """,
        contents: "맛있어요 추천해요",
        likeCount: 1
      )
    ]
    return .just(posts)
  }
}
