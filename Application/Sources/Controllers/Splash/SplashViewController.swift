//
//  SplashViewController.swift
//  MyApp
//
//  Created by bongzniak on 2020/12/21.
//

import ReactorKit
import AsyncDisplayKit
import RxSwift
import RxCocoa
import RxCocoa_Texture
import PureSwinject

final class SplashViewController: BaseViewController, View, FactoryModule {

  typealias Reactor = SplashViewReactor
  typealias Node = SplashViewController

  // MARK: Dependency

  struct Dependency {
    let reactor: SplashViewReactor
  }

  // MARK: Constants

  fileprivate struct Metric {

  }

  // MARK: Properties

  fileprivate let reactor: Reactor


  // MARK: Nodes

  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    reactor = dependency.reactor

    super.init()

    // main thread
    node.onDidLoad({ _ in })
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

  }

  // MARK: Configuring

  func bind(reactor: SplashViewReactor) {

    // Action
    rx.viewDidAppear
        .map { _ in
          Reactor.Action.checkIfAuthenticated
        }
        .bind(to: reactor.action)
        .disposed(by: self.disposeBag)

    // State
    reactor.state.map {
          $0.isAuthenticated
        }
        .filterNil()
        .distinctUntilChanged()
        .subscribe(onNext: { _ in })
        .disposed(by: self.disposeBag)
  }
}
