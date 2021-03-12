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
    static let abuSize: CGSize = .init(width: 40.f, height: 40.f)
  }

  enum Style {
    static let name = StringStyle(
      .font(UIFont.boldSystemFont(ofSize: 24.f))
    )
    static let description = StringStyle(
      .font(UIFont.systemFont(ofSize: 17.f))
    )
    static let beerKind = StringStyle(
      .font(UIFont.systemFont(ofSize: Metric.informationFontSize))
    )
    static let abuTitle = StringStyle(
      .font(UIFont.boldSystemFont(ofSize: 10.f)),
      .color(.white)
    )
    static let abu = StringStyle(
      .font(UIFont.boldSystemFont(ofSize: Metric.informationFontSize)),
      .color(.white)
    )
    static let suggestTitle = StringStyle(
      .font(UIFont.boldSystemFont(ofSize: 16.f))
    )
    static let suggest = StringStyle(
      .font(UIFont.boldSystemFont(ofSize: 24.f))
    )
  }

  // MARK: Properties

  // MARK: Node

  lazy var scrollNode = BaseASScrollNode()
  lazy var nameTextNode = BaseASTextNode()

  lazy var beerKindTextNode = BaseASTextNode()
  var beerTypeImageWithTextNode: ASImageWithTextNode?
  var nationImageWithTextNode: ASImageWithTextNode?

  var abuTitleTextNode = BaseASTextNode()
  var abuTextNode = BaseASTextNode()

  lazy var beerGlassImageNode = ASNetworkImageNode().then {
    $0.style.preferredSize = CGSize(width: 30.f, height: 30.f)
  }
  lazy var ratingNode = BaseASTextNode()

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
      var nodes: [AnyDisplayNode] = []

      let nameNode = self.makeNameNode()
      nodes.append(nameNode)

      let informationNode = self.makeInformationNode().then {
        $0.style.spacingBefore = 10.f
      }
      nodes.append(informationNode)

      let suggestNode = self.makeSuggestNode().then {
        $0.style.spacingBefore = 26.f
      }
      nodes.append(suggestNode)

      let imagesNode = self.makeImagesNode().then {
        $0.style.spacingBefore = 16.f
      }
      nodes.append(imagesNode)

      let contentsNode = self.makeContentsNode().then {
        $0.style.spacingBefore = 36.f
      }
      nodes.append(contentsNode)

      return LayoutSpec {
        VStackLayout {
          nodes
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
      .bind(to: nameTextNode.rx.text(Style.name.attributes),
            setNeedsLayout: node)
      .disposed(by: disposeBag)

    reactor.state
      .map {
        $0.beer?.kind.text
      }
      .bind(to: beerKindTextNode.rx.text(Style.beerKind.attributes),
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
        $0.beer?.abv
      }
      .filterNil()
      .map {
        "\($0)"
      }
      .bind(to: abuTextNode.rx.text(Style.abu.attributes))
      .disposed(by: disposeBag)

    reactor.state
      .map {
        $0.beer?.glass.imageURLString
      }
      .filterNil()
      .map {
        URL(string: $0)
      }
      .bind(to: beerGlassImageNode.rx.url)
      .disposed(by: disposeBag)

    reactor.state
      .map {
        $0.beer?.rating
      }
      .filterNil()
      .map {
        "\($0)"
      }
      .bind(to: ratingNode.rx.text(Style.suggest.attributes))
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
        self?.noseNode?.layoutIfNeeded()
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
        self?.tasteNode?.layoutIfNeeded()
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
        self?.opinionNode?.layoutIfNeeded()
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
  private func makeNameNode() -> AnyDisplayNode {
    let nameNode = AnyDisplayNode { _, _ in
      LayoutSpec {
        InsetLayout(insets: .init(horizontalInset: 16.f)) {
          self.nameTextNode
        }
      }
    }
    return nameNode
  }

  private func makeInformationNode() -> AnyDisplayNode {
    let informationElements = [
      beerKindTextNode, beerTypeImageWithTextNode, nationImageWithTextNode
    ].compactMap {
      $0
    }

    let abuNode = maekABUNode()
    return AnyDisplayNode { _, _ in
      LayoutSpec {
        HStackLayout(spacing: 10.f, alignItems: .center) {
          informationElements
          HSpacerLayout()
          abuNode
        }.padding(.horizontal, 16.f)
      }
    }
  }

  private func maekABUNode() -> ASDisplayNode {
    AnyDisplayNode { [weak self] _, _ in
      guard let `self` = self, self.reactor?.currentState.beer?.abv != nil
      else {
        return LayoutSpec {
        }
      }

      self.abuTitleTextNode.attributedText = "ABU".styled(with: Style.abuTitle)

      return LayoutSpec {
        RelativeLayout(horizontalPosition: .start) {
          self.abuTitleTextNode
            .padding(.left, 2.f)
        }
        CenterLayout {
          self.abuTextNode
        }
      }
    }.then {
      $0.style.minWidth = ASDimension(unit: .points, value: Metric.abuSize.width)
      $0.style.minHeight = ASDimension(unit: .points, value: Metric.abuSize.height)
      $0.backgroundColor = .darkText
      $0.cornerRadius = 4.f
      $0.clipsToBounds = true
    }
  }

  private func makeSuggestNode() -> AnyDisplayNode {
    AnyDisplayNode { [unowned self] _, _ in
      LayoutSpec {
        HStackLayout {
          VStackLayout(spacing: 10.f) {
            ASTextNode().then {
              $0.attributedText = "추천 술잔".styled(with: Style.suggestTitle)
            }
            beerGlassImageNode
          }
            .flexGrow(1.f)
          VStackLayout(spacing: 10.f) {
            ASTextNode().then {
              $0.attributedText = "추천 점수".styled(with: Style.suggestTitle)
            }
            ratingNode
          }
            .flexGrow(1.f)
        }
          .padding(.horizontal, 16.f)
      }
    }
  }

  private func makeImagesNode() -> AnyDisplayNode {
    guard let images = reactor?.currentState.beer?.images
    else {
      return AnyDisplayNode { _, _ in
        LayoutSpec {
        }
      }
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

    return AnyDisplayNode { _, _ in
      LayoutSpec {
        VStackLayout(spacing: 16.f) {
          elements
        }
      }
    }
  }

  private func makeContentsNode() -> AnyDisplayNode {
    let elements = [noseNode, tasteNode, opinionNode]
      .compactMap {
      $0
    }

    return AnyDisplayNode { _, _ in
      LayoutSpec {
        VStackLayout(spacing: 26.f) {
          elements
        }.padding(.horizontal, 16.f)
      }
    }
  }
}
