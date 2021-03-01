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

  lazy var imageNode = ASNetworkImageNode().then {
    $0.contentMode = .scaleAspectFill
//    $0.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(0, nil)
//    $0.backgroundColor = .red
//    $0.layer.cornerRadius = 25.f
//    $0.layer.masksToBounds = true
  }
  lazy var contentsNode = ASTextNode()
  lazy var timeIntervalLabel = ASTextNode()

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
      .bind(to: contentsNode.rx.text(Node.contentsStyle.attributes), setNeedsLayout: self)
      .disposed(by: disposeBag)
  }

  // MARK: Layout Spec

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

    var headerChildren: [ASLayoutElement] = []

    let headerStack = ASStackLayoutSpec.horizontal()
    headerStack.alignItems = .center
    headerStack.spacing = 10.f

    imageNode.style.preferredSize = CGSize(width: 50.f, height: 50.f)
    imageNode.backgroundColor = .red
    headerChildren.append(imageNode)

    contentsNode.style.grow(1.f)
    headerChildren.append(contentsNode)

    let spacer = ASLayoutSpec()
    spacer.style.flexGrow = 1.f
    headerChildren.append(spacer)

    timeIntervalLabel.attributedText = "now".styled(with: Node.contentsStyle)
    headerChildren.append(timeIntervalLabel)

    headerStack.children = headerChildren

    let verticalStack = ASStackLayoutSpec.vertical()
    verticalStack.children = [
      ASInsetLayoutSpec(insets: .init(horizontalInset: 16.f), child: headerStack)
    ]
    verticalStack.style.width = ASDimension(unit: .points, value: 375.f)
    return verticalStack
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
