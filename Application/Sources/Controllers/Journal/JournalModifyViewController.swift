//
//  JournalModifyViewController.swift
//  Application
//
//  Created by bongzniak on 2021/03/08.
//
//

import Foundation
import UIKit

import Pure
import ReactorKit
import AsyncDisplayKit
import TextureSwiftSupport
import RxSwift
import RxCocoa_Texture
import URLNavigator
import BonMot

final class JournalModifyViewController: BaseViewController, FactoryModule, View {

  typealias Node = JournalModifyViewController
  typealias Reactor = JournalModifyViewReactor

  // MARK: Dependency

  struct Dependency {
    let navigator: NavigatorType
    let reactorFactory: (_ id: String?) -> Reactor
    let codeListViewControllerFactory: CodeListViewController.Factory
  }

  struct Payload {
    let id: String?
  }

  // MARK: Constants

  enum Style {
    static let namePlaceHolder = StringStyle(
      .font(UIFont.systemFont(ofSize: 12.f)),
      .color(UIColor.gray)
    )

    static let beerCode = StringStyle(
      .font(UIFont.systemFont(ofSize: 16.f))
    )
  }

  // MARK: Properties

  let navigator: NavigatorType
  let codeListViewControllerFactory: CodeListViewController.Factory

  // MARK: Node

  lazy var scrollNode = BaseASScrollNode()

  lazy var nameText = ASEditableTextNode().then {
    $0.attributedPlaceholderText = "맥주 이름을 입력해주세요.".styled(with: Style.namePlaceHolder)
    $0.textContainerInset = .zero
    $0.backgroundColor = .blue
    $0.delegate = self
    $0.maximumLinesToDisplay = 5
  }

  lazy var beerKindButton = ASButtonNode().then {
    $0.style.preferredSize = .init(width: 100.f, height: 60.f)
    $0.backgroundColor = .blue
  }

  lazy var beerTypeButton = ASButtonNode().then {
    $0.style.preferredSize = .init(width: 100.f, height: 60.f)
    $0.backgroundColor = .gray
  }

  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    defer {
      reactor = dependency.reactorFactory(payload.id)
    }

    navigator = dependency.navigator
    codeListViewControllerFactory = dependency.codeListViewControllerFactory

    super.init()
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    scrollNode.layoutSpecBlock = { [unowned self] _, _ in
      let elements = [nameText, beerKindButton, beerTypeButton]
      return LayoutSpec {
        VStackLayout {
          elements
        }
          .padding(.vertical, 16.f)
      }
    }
  }

  // MARK: Configuring

  func bind(reactor: Reactor) {

    // Action

    beerKindButton.rx.tap
      .flatMap { [unowned self] in
        selectedCode(groupCodeType: .beerKind)
      }
      .map {
        Reactor.Action.updateBeerKindCode($1)
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    beerTypeButton.rx.tap
      .flatMap { [unowned self] in
        selectedCode(groupCodeType: .beerType)
      }
      .map {
        Reactor.Action.updateBeerTypeCode($1)
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // State

    reactor.state
      .map {
        $0.beerKindCode?.text
      }
      .bind(to: beerKindButton.rx.text(Style.beerCode.attributes, target: .normal))
      .disposed(by: disposeBag)

    reactor.state
      .map {
        $0.beerTypeCode?.text
      }
      .bind(to: beerTypeButton.rx.text(Style.beerCode.attributes, target: .normal))
      .disposed(by: disposeBag)
  }

  func selectedCode(
    groupCodeType: GroupCodeType
  ) -> Observable<(groupCodeType: GroupCodeType, code: Code)> {
    let vc = codeListViewControllerFactory.create(payload: .init(groupCodeType: groupCodeType))
    navigator.push(vc)
    return vc.selectedCode
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

// MARK: ASEditableTextNodeDelegate

extension JournalModifyViewController: ASEditableTextNodeDelegate {
  func editableTextNodeDidUpdateText(_ editableTextNode: ASEditableTextNode) {
    editableTextNode.supernode?.setNeedsLayout()
  }
}
