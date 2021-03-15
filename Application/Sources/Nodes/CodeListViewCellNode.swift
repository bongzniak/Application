//
//  CodeListViewCellCellNode.swift
//  Application
//
//  Created by bongzniak on 2021/03/15.
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
import BonMot

final class CodeListViewCellNode: BaseASCellNode, FactoryModule, View {

  typealias Node = CodeListViewCellNode
  typealias Reactor = CodeListViewCellReactor

  // MARK: Dependency

  struct Dependency {
    let reactorFactory: (GroupCodeType, Code) -> Reactor
  }

  struct Payload {
    let groupCodeType: GroupCodeType
    let code: Code
  }

  // MARK: Constants

  enum Style {
    static let nameText = StringStyle(
      .font(.systemFont(ofSize: 16.f))
    )
  }

  // MARK: Properties

  // MARK: Node

  lazy var nameTextNode = BaseASTextNode()

  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    defer { reactor = dependency.reactorFactory(payload.groupCodeType, payload.code) }

    super.init()
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Configuring

  func bind(reactor: Reactor) {

    reactor.state.map { $0.code.text }
      .bind(to: nameTextNode.rx.text(Style.nameText.attributes))
  }

  // MARK: Layout Spec

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    LayoutSpec {
      WrapperLayout {
        InsetLayout(insets: .init(verticalInset: 16.f, horizontalInset: 10.f)) {
          nameTextNode
        }
      }
    }
  }
}
