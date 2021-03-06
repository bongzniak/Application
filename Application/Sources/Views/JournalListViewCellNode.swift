//
//  JournalListViewCellNode.swift
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

final class JournalListViewCellNode: BaseASCellNode, FactoryModule, View {

  typealias Node = JournalListViewCellNode
  typealias Reactor = JournalListViewCellReactor

  // MARK: Dependency

  struct Dependency {
    let reactorFactory: (_ beer: Beer) -> JournalListViewCellReactor
  }

  struct Payload {
    let beer: Beer
  }

  // MARK: Constants

  enum Metric {
    static let wrapperInset: UIEdgeInsets = .init(verticalInset: 10.f, horizontalInset: 16.f)
    static let cellMinHeight = 100.f
    static let spacing = 4.f
    static let imageSize: CGSize = .init(width: 100.f, height: 100.f)
    static let informationImageSize: CGSize = .init(width: 25.f, height: 25.f)
    static let imageCornerRadius = 5.f
    static let imageAfterSpacing = 16.f
  }

  enum Attribute {
    static var titleAttributes = StringStyle(
      .font(UIFont.boldSystemFont(ofSize: 16.f))
    ).attributes
    static var opinionAttributes = StringStyle(
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
  lazy var nameNode = BaseASTextNode().then {
    $0.maximumNumberOfLines = 1
  }
  lazy var opinionNode = BaseASTextNode().then {
    $0.maximumNumberOfLines = 2
  }
  lazy var beerTypeImageNode = ASNetworkImageNode().then {
    $0.contentMode = .scaleAspectFill
    $0.style.preferredSize = Metric.informationImageSize
  }
  lazy var beerGlassImageNode = ASNetworkImageNode().then {
    $0.contentMode = .scaleAspectFill
    $0.style.preferredSize = Metric.informationImageSize
  }
  var informationNodes: [ASImageWithTextNode] = []

  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    defer {
      reactor = dependency.reactorFactory(payload.beer)
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
        [(Image.commentImage, $0.beer.commentCount), (Image.likeImage, $0.beer.likeCount)]
          .filter {
          $0.1 > 0
        }
      }
      .subscribe(onNext: { [weak self] in
        self?.informationNodes = $0.map {
          ASImageWithTextNode(
            image: $0.0,
            text: "\($0.1)"
          )
        }
      })
      .disposed(by: disposeBag)

    reactor.state
      .map {
        URL(string: $0.beer.images.first ?? "")
      }
      .bind(to: imageNode.rx.url,
            setNeedsLayout: self)
      .disposed(by: disposeBag)

    reactor.state
      .map {
        $0.beer.name
      }
      .bind(to: nameNode.rx.text(Attribute.titleAttributes),
            setNeedsLayout: self)
      .disposed(by: disposeBag)

    reactor.state
      .map {
        $0.beer.opinion
      }
      .bind(to: opinionNode.rx.text(Attribute.opinionAttributes),
            setNeedsLayout: self)
      .disposed(by: disposeBag)

    reactor.state
      .map {
        URL(string: $0.beer.type.imageURLString)
      }
      .bind(to: beerTypeImageNode.rx.url,
            setNeedsLayout: self)
      .disposed(by: disposeBag)

    reactor.state
      .map {
        URL(string: $0.beer.glass.imageURLString)
      }
      .bind(to: beerGlassImageNode.rx.url,
            setNeedsLayout: self)
      .disposed(by: disposeBag)
  }

  // MARK: Layout Spec

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let node = makeWrapperNode()

    return LayoutSpec {
      InsetLayout(insets: Metric.wrapperInset) {
        node
      }
    }
  }
}

// MARK: Layout Spec

extension JournalListViewCellNode {
  func makeWrapperNode() -> ASDisplayNode {
    let contentsAndInformationNode = makeContentsAndInformationNode()

    var element = [contentsAndInformationNode]

    if imageNode.url != nil {
      element.insert(imageNode, at: 0)
    }

    return AnyDisplayNode { _, _ in
      LayoutSpec {
        HStackLayout(spacing: Metric.imageAfterSpacing) {
          element
        }.minSize(Metric.imageSize)
      }
    }
  }

  func makeContentsAndInformationNode() -> ASDisplayNode {
    let contentsNode = makeContentsNode(elements: [nameNode, opinionNode]).then {
      $0.style.shrinkAndGrow(1.f)
    }
    let informationNode = makeInformationNode()

    return AnyDisplayNode { _, _ in
      LayoutSpec {
        VStackLayout(spacing: Metric.spacing, justifyContent: .spaceBetween) {
          contentsNode
          informationNode
        }
      }
    }.then {
      $0.style.shrinkAndGrow(1.f)
    }
  }

  func makeContentsNode(elements: [ASDisplayNode]) -> ASDisplayNode {
    AnyDisplayNode { _, _ in
      LayoutSpec {
        VStackLayout(spacing: Metric.spacing) {
          elements
        }
      }
    }
  }

  func makeInformationNode() -> ASDisplayNode {
    var nodes: [ASDisplayNode] = [beerTypeImageNode, beerGlassImageNode]
      .filter {
      $0.url != nil
    }

//    let spaceNode = makeSpaceNode()
//    nodes.append(spaceNode)
//
//    if informationNodes.isNotEmpty {
//      nodes.append(contentsOf: informationNodes)
//    }

    return AnyDisplayNode { _, _ in
      LayoutSpec {
        HStackLayout(spacing: Metric.spacing, alignItems: .baselineLast) {
          nodes
        }
      }
    }
  }

  func makeSpaceNode() -> ASDisplayNode {
    AnyDisplayNode { _, _ in
      LayoutSpec {
        HSpacerLayout()
      }
    }.then {
      $0.style.shrinkAndGrow(1.f)
    }
  }
}
