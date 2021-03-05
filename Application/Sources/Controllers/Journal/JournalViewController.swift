//
//  JournalViewController.swift
//  Application
//
//  Created by bongzniak on 2021/03/05.
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

final class JournalViewController: BaseViewController, FactoryModule, View {

  typealias Node = JournalViewController
  typealias Reactor = JournalViewReactor

  // MARK: Dependency

  struct Dependency {
    let reactorFactory: (String) -> Reactor
  }

  struct Payload {
    let beerID: String
  }

  // MARK: Constants

  enum Metric {
    static let insets: UIEdgeInsets = .init(verticalInset: 10.f, horizontalInset: 16.f)
    static let informationImageSize: CGSize = .init(width: 18.f, height: 18.f)
    static let informationFontSize: CGFloat = 14.f
  }

  enum AttributeStyle {
    static let nameStyle = StringStyle(
      .font(UIFont.boldSystemFont(ofSize: 24.f))
    )
    static let descriptionStyle = StringStyle(
      .font(UIFont.systemFont(ofSize: 17.f))
    )
    static let beerKindStyle = StringStyle(
      .font(UIFont.systemFont(ofSize: Metric.informationFontSize))
    )
  }

  // MARK: Properties

  // MARK: Node

  lazy var scrollNode = BaseASScrollNode()
  lazy var nameTextNode = BaseASTextNode()

  lazy var beerKindTextNode = BaseASTextNode()
  var beerTypeImageWithTextNode: ASImageWithTextNode?
  var nationImageWithTextNode: ASImageWithTextNode?

  var abuDisplayNode = ASDisplayNode()
  var abuTitleTextNode = BaseASTextNode()
  var abuTextNode = BaseASTextNode()

  lazy var beerGlassTextNode = BaseASTextNode()
  lazy var beerGlassImageNode = ASNetworkImageNode()

  lazy var ratingTextNode = BaseASTextNode()
  lazy var ratingNode = ASDisplayNode()

  var apperanceNode: TitleWithDescriptionNode?
  var noseNode: TitleWithDescriptionNode?
  var tasteNode: TitleWithDescriptionNode?
  var opinionNode: TitleWithDescriptionNode?

  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    defer {
      reactor = dependency.reactorFactory(payload.beerID)
    }

    super.init()
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    scrollNode.layoutSpecBlock = { _, _ -> ASLayoutSpec in
      var elements: [ASLayoutSpec] = []

      let nameLayout = ASInsetLayoutSpec(
        insets: .init(horizontalInset: 16.f),
        child: self.nameTextNode
      )
      elements.append(nameLayout)

      let informationLayout = self.informationLayoutSpec().then {
        $0.style.spacingBefore = 10.f
      }
      elements.append(informationLayout)

      let imageLayout = self.imageLayoutSpec()
      elements.append(imageLayout)

      let contentsLayout = self.contentsLayoutSpec().then {
        $0.style.spacingBefore = 36.f
      }
      elements.append(contentsLayout)

      return LayoutSpec {
        VStackLayout {
          elements
        }.padding(.vertical, 16.f)
      }
    }
  }

  // MARK: Configuring

  func bind(reactor: Reactor) {

    // Action

    rx.viewDidLoad.map {
        Reactor.Action.refresh
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // State

    reactor.state
      .map {
        $0.beer?.name
      }
      .bind(to: nameTextNode.rx.text(AttributeStyle.nameStyle.attributes),
            setNeedsLayout: node)
      .disposed(by: disposeBag)

    reactor.state
      .map {
        $0.beer?.kind.text
      }
      .bind(to: beerKindTextNode.rx.text(AttributeStyle.beerKindStyle.attributes),
            setNeedsLayout: node)
      .disposed(by: disposeBag)

    reactor.state
      .map {
        $0.beer?.type
      }
      .filterNil()
      .bind { [weak self] code in
        self?.beerTypeImageWithTextNode = self?.renderImageWithTextNode(
          code.imageURLString, with: code.text
        )
      }
      .disposed(by: disposeBag)

    reactor.state
      .map {
        $0.beer?.nation
      }
      .filterNil()
      .bind { [weak self] code in
        self?.nationImageWithTextNode = self?.renderImageWithTextNode(
          code.imageURLString, with: code.text
        )
      }
      .disposed(by: disposeBag)

    reactor.state
      .map {
        $0.beer?.apperance
      }
      .bind { [weak self] apperance in
        guard let apperance = apperance
        else {
          self?.apperanceNode = nil
          return
        }
        self?.apperanceNode = TitleWithDescriptionNode(title: "외관", description: apperance)
        self?.apperanceNode?.setNeedsLayout()
      }
      .disposed(by: disposeBag)

    reactor.state
      .map {
        $0.beer?.nose
      }
      .bind { [weak self] nose in
        guard let nose = nose
        else {
          self?.noseNode = nil
          return
        }
        self?.noseNode = TitleWithDescriptionNode(title: "향", description: nose)
        self?.noseNode?.setNeedsLayout()
      }
      .disposed(by: disposeBag)

    reactor.state
      .map {
        $0.beer?.taste
      }
      .bind { [weak self] taste in
        guard let taste = taste
        else {
          self?.tasteNode = nil
          return
        }
        self?.tasteNode = TitleWithDescriptionNode(title: "맛", description: taste)
        self?.tasteNode?.setNeedsLayout()
      }
      .disposed(by: disposeBag)

    reactor.state
      .map {
        $0.beer?.opinion
      }
      .bind { [weak self] opinion in
        guard let opinion = opinion
        else {
          self?.opinionNode = nil
          return
        }
        self?.opinionNode = TitleWithDescriptionNode(title: "총평", description: opinion)
        self?.opinionNode?.setNeedsLayout()
      }
      .disposed(by: disposeBag)
  }

  // MARK: Private func

  private func renderImageWithTextNode(
    _ imageUrlString: String, with text: String
  ) -> ASImageWithTextNode {
    ASImageWithTextNode(
      imageURLString: imageUrlString,
      imageSize: Metric.informationImageSize,
      text: text,
      fontSize: Metric.informationFontSize
    )
  }

  // MARK: Layout Spec

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    LayoutSpec {
      WrapperLayout {
        scrollNode
      }
    }
  }
}

// MARK: Layout Spec

extension JournalViewController {
  private func informationLayoutSpec() -> ASLayoutSpec {
    let informationElements = [
      beerKindTextNode, beerTypeImageWithTextNode, nationImageWithTextNode
    ].compactMap {
      $0
    }

    return LayoutSpec {
      HStackLayout(spacing: 10.f, alignItems: .center) {
        informationElements
      }.padding(.horizontal, 16.f)
    }
  }

  private func imageLayoutSpec() -> ASLayoutSpec {
    guard let images = reactor?.currentState.beer?.images
    else {
      return ASLayoutSpec()
    }

    let elements: [ASLayoutSpec] = images
      .map {
        URL(string: $0)
      }
      .compactMap {
        $0
      }
      .map {
        let imageNode = ASNetworkImageNode().then {
          $0.contentMode = .scaleAspectFill
          $0.style.width = ASDimension(unit: .fraction, value: 1.f)
          $0.style.shrinkAndGrow(1.f)
        }
        imageNode.url = $0
        return ASRatioLayoutSpec(ratio: 1.f, child: imageNode)
      }

    return LayoutSpec {
      VStackLayout(spacing: 16.f) {
        elements
      }.padding(.top, 16.f)
    }
  }

  private func contentsLayoutSpec() -> ASLayoutSpec {
    let elements = [apperanceNode, noseNode, tasteNode, opinionNode]
      .compactMap {
      $0
    }

    return LayoutSpec {
      VStackLayout(spacing: 26.f) {
        elements
      }.padding(.horizontal, 16.f)
    }
  }
}
