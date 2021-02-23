//
//  SplashViewController.swift
//  MyApp
//
//  Created by bongzniak on 2020/12/21.
//
import Foundation
import UIKit

import Pure
import ReactorKit
import AsyncDisplayKit
import RxSwift
import RxCocoa_Texture
import URLNavigator

final class SplashViewController: BaseViewController, FactoryModule, View {

  typealias Node = SplashViewController
  typealias Reactor = SplashViewReactor

  // MARK: Dependency

  struct Dependency {
    let reactor: Reactor
    let window: UIWindow
    let loginViewControllerFactory: LoginViewController.Factory
    let mainTabBarControllerFactory: MainTabBarController.Factory
  }

  // MARK: Properties

  fileprivate let window: UIWindow
  fileprivate let loginViewControllerFactory: LoginViewController.Factory
  fileprivate let mainTabBarControllerFactory: MainTabBarController.Factory

  // MARK: Nodes

  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    defer { reactor = dependency.reactor }
    window = dependency.window
    loginViewControllerFactory = dependency.loginViewControllerFactory
    mainTabBarControllerFactory = dependency.mainTabBarControllerFactory

    super.init()

    view.backgroundColor = .yellow
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Configuring

  func bind(reactor: Reactor) {

    // Action
    rx.viewDidAppear
      .map { _ in Reactor.Action.checkIfAuthenticated }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    // State
    reactor.state.map { $0.isAuthenticated }
      .filterNil()
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] isAuthenticated in
        self?.window.rootViewController = isAuthenticated
          ? self?.mainTabBarControllerFactory.create()
          : self?.loginViewControllerFactory.create()
      })
      .disposed(by: self.disposeBag)
  }
}
