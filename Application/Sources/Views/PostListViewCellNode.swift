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

  enum Metric {
    static let wrapperInset: UIEdgeInsets = .init(verticalInset: 10.f, horizontalInset: 16.f)
    static let cellMinHeight = 80.f
    static let spacing = 4.f
    static let imageSize: CGSize = .init(width: 80.f, height: 80.f)
    static let imageCornerRadius = 5.f
    static let imageAfterSpacing = 16.f
  }

  enum Attribute {
    static var titleAttributes = StringStyle(
      .font(UIFont.boldSystemFont(ofSize: 16.f))
    ).attributes
    static var contentsAttributes = StringStyle(
      .font(UIFont.systemFont(ofSize: 12.f))
    ).attributes
  }

  enum ImageConfigration {
    static let informationSymbolSize = UIImage.SymbolConfiguration(pointSize: 12.f)
  }

  enum Image {
    static let commentImage = UIImage(
      systemName: "bubble.left.and.bubble.right",
      withConfiguration: ImageConfigration.informationSymbolSize
    )
    static let likeImage = UIImage(
      systemName: "heart",
      withConfiguration: ImageConfigration.informationSymbolSize
    )
  }

  // MARK: Properties

  // MARK: Node

  lazy var imageNode = ASNetworkImageNode().then {
    $0.contentMode = .scaleAspectFill
    $0.cornerRadius = Metric.imageCornerRadius
    $0.clipsToBounds = true

    $0.style.preferredSize = Metric.imageSize
    $0.style.shrink(0.f).grow(0.f)
  }
  lazy var titleNode = BaseASTextNode().then {
    $0.maximumNumberOfLines = 2
  }
  lazy var contentsNode = BaseASTextNode().then {
    $0.maximumNumberOfLines = 1
  }
  var informationNodes: [ImageWithTextNode] = []

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

    reactor.state.map {
        [(Image.commentImage, $0.commentCount),
         (Image.likeImage, $0.likeCount)].filter { $0.1 > 0 }
      }
      .subscribe(onNext: { [weak self] items in
        for item in items {
          let node = ImageWithTextNode(image: item.0, text: "\(item.1)")
          self?.informationNodes.append(node)
        }
      })
      .disposed(by: disposeBag)

    reactor.state
      .map {
        $0.imageURL
      }
      .bind(to: imageNode.rx.url, setNeedsLayout: self)
      .disposed(by: disposeBag)

    reactor.state
      .map {
        $0.title
      }
      .bind(to: titleNode.rx.text(Attribute.titleAttributes),
            setNeedsLayout: self)
      .disposed(by: disposeBag)

    reactor.state
      .map {
        $0.contents
      }
      .bind(to: contentsNode.rx.text(Attribute.contentsAttributes),
            setNeedsLayout: self)
      .disposed(by: disposeBag)
  }

  // MARK: Layout Spec

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let layout = wrapperLayoutSpec().setFitWidth()
    return ASInsetLayoutSpec(insets: Metric.wrapperInset, child: layout)
  }
}

// MARK: Layout Spec

extension PostListViewCellNode {
  func wrapperLayoutSpec() -> ASLayoutSpec {
    let contentsAndInformationLayout = contentsAndInformationLayoutSpec()

    var element: [ASLayoutElement] = [contentsAndInformationLayout]

    if let _ = imageNode.url {
      element.insert(imageNode, at: 0)
    }

    return ASStackLayoutSpec(
      direction: .horizontal,
      spacing: Metric.imageAfterSpacing,
      justifyContent: .start,
      alignItems: .stretch,
      children: element
    ).then{
      $0.style.minHeight = ASDimension(unit: .points, value: Metric.cellMinHeight)
    }
  }

  func contentsAndInformationLayoutSpec() -> ASLayoutSpec {
    let contentsLayout = contentsLayoutSpec()
    let informationLayout = informationLayoutSpec()

    return ASStackLayoutSpec(
      direction: .vertical,
      spacing: Metric.spacing,
      justifyContent: .spaceBetween,
      alignItems: .stretch,
      children: [contentsLayout, informationLayout]
    ).then {
      $0.style.shrink(1.0).grow(1.0)
    }
  }

  func contentsLayoutSpec() -> ASLayoutSpec {
    ASStackLayoutSpec(
      direction: .vertical,
      spacing: Metric.spacing,
      justifyContent: .start,
      alignItems: .stretch,
      children: [titleNode, contentsNode]
    )
  }

  func informationLayoutSpec() -> ASLayoutSpec {
    return ASStackLayoutSpec(
      direction: .horizontal,
      spacing: Metric.spacing,
      justifyContent: .start,
      alignItems: .center,
      children: informationNodes
    )
  }
}
