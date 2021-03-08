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
import RxSwift
import RxCocoa_Texture
import URLNavigator

final class JournalModifyViewController: BaseViewController, FactoryModule, View {

  typealias Node = JournalModifyViewController
  typealias Reactor = JournalModifyViewReactor

  // MARK: Dependency

  struct Dependency {
    let reactor: Reactor
  }

  // MARK: Constants

  // MARK: Properties

  // MARK: Node

  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    defer { reactor = dependency.reactor }

    super.init()
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Configuring

  func bind(reactor: Reactor) {
  }

  // MARK: Layout Spec

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    ASLayoutSpec()
  }
}
