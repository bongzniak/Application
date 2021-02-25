//
//  LoginViewController.swift
//  Application
//
//  Created by bongzniak on 2021/02/23.
//
//

import Foundation
import UIKit

import Pure
import ReactorKit
import AsyncDisplayKit
import RxSwift
import RxCocoa_Texture
import Then
import SwiftyColor

final class LoginViewController: BaseViewController, FactoryModule, View {

  typealias Node = LoginViewController
  typealias Reactor = LoginViewReactor

  // MARK: Dependency

  struct Dependency {
    let reactor: Reactor
    let window: UIWindow
    let mainTabBarControllerFactory: MainTabBarController.Factory
  }

  // MARK: Constants

  private enum Metric {
    static let buttonLayoutSpecSpacing = 10.f
    static let buttonNodeHeighgt = 50.f
  }

  private enum Font {
    static let buttonFont = UIFont.boldSystemFont(ofSize: 16.f)
  }

  // MARK: Properties

  fileprivate let window: UIWindow
  fileprivate let mainTabBarControllerFactory: MainTabBarController.Factory

  // MARK: Node

  private let facebookButtonNode = ASButtonNode().then {
    $0.layer.cornerRadius = 10.f
    $0.layer.masksToBounds = true
    $0.backgroundColor = 0x3b5998.color
    $0.setTitle("Login with Facebook",
                with: Font.buttonFont,
                with: .white,
                for: .normal)
  }

  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    defer { reactor = dependency.reactor }
    window = dependency.window
    mainTabBarControllerFactory = dependency.mainTabBarControllerFactory

    super.init()
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Configuring

  func bind(reactor: Reactor) {
    window.rootViewController = mainTabBarControllerFactory.create()
  }

  // MARK: Layout Spec

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let buttonLayout = loginButtonsLayoutSpec()
    let insetLayout = ASInsetLayoutSpec(insets: view.safeAreaInsets, child: buttonLayout)
    return ASInsetLayoutSpec(
      insets: .init(top: 0, left: 16.f, bottom: 0, right: 16.f),
      child: insetLayout
    )
  }
}

// MARK: - Layout Spec

extension LoginViewController {
  private func loginButtonsLayoutSpec() -> ASLayoutSpec {

    facebookButtonNode.style.height = .init(unit: .points, value: Metric.buttonNodeHeighgt)
    return ASStackLayoutSpec(
      direction: .vertical,
      spacing: Metric.buttonLayoutSpecSpacing,
      justifyContent: .end,
      alignItems: .stretch,
      children: [facebookButtonNode]
    )
  }
}
