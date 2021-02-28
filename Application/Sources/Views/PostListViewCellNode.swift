//
//  PostListViewCellNode.swift
//  Application
//
//  Created by bongzniak on 2021/02/28.
//
//

import Foundation
import UIKit

import Pure
import ReactorKit
import AsyncDisplayKit
import RxSwift
import RxCocoa_Texture
import TextureSwiftSupport
import BonMot

final class PostListViewCellNode: BaseCellNode, FactoryModule, View {

  typealias Node = PostListViewCellNode
  typealias Reactor = PostListViewCellReactor

  // MARK: Dependency

  struct Dependency {
    let reactorFactory: (_ post: Post) -> PostListViewCellReactor
  }

  struct Payload {
    let post: Post
  }

  // MARK: Constants

  // MARK: Properties

  // MARK: Node

  lazy var contentNode = ASTextNode()

  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    defer {
      reactor = dependency.reactorFactory(payload.post)
    }

    super.init()
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Configuring

  func bind(reactor: Reactor) {
    reactor.state
      .map {
        $0.contents
      }
      .asObservable()
      .bind(to: contentNode.rx.text(Node.contentsStyle.attributes), setNeedsLayout: self)
      .disposed(by: disposeBag)
  }

  // MARK: Layout Spec

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let spec = ASWrapperLayoutSpec(layoutElement: contentNode)
    return ASInsetLayoutSpec(insets: .init(verticalInset: 10.f, horizontalInset: 10.f),
                             child: spec)
  }
}


// MARK: - String style

extension PostListViewCellNode {
  static var contentsStyle: StringStyle {
    StringStyle(
      .font(UIFont.systemFont(ofSize: 10.f))
    )
  }
}
