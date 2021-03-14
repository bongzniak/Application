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
    let reactorFactory: (String?) -> Reactor
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
  }

  // MARK: Properties

  // MARK: Node

  lazy var scrollNode = BaseASScrollNode()

  lazy var nameText = ASEditableTextNode().then {
    $0.attributedPlaceholderText = "맥주 이름을 입력해주세요.".styled(with: Style.namePlaceHolder)
    $0.textContainerInset = .zero
    $0.backgroundColor = .blue
    $0.delegate = self
    $0.maximumLinesToDisplay = 5
  }

  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    defer {
      reactor = dependency.reactorFactory(payload.id)
    }

    super.init()
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    scrollNode.layoutSpecBlock = { [unowned self] _, _ in
      let elements = [nameText]
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

    // nameText.rx.
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
