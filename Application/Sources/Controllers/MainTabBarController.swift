//
// Created by bongzniak on 2021/01/18.
//

import UIKit

import Pure
import ReactorKit
import RxCocoa
import RxSwift

struct TabBarItem {
  let title: String
  let viewController: UIViewController
  let image: UIImage
}

final class MainTabBarController: UITabBarController, View, FactoryModule {

  typealias Node = MainTabBarController
  typealias Reactor = MainTabBarViewReactor

  // MARK: Dependency

  struct Dependency {
    let reactor: MainTabBarViewReactor
  }

  // MARK: Payload

  struct Payload {
    let version: Int
  }

  // MARK: Constants

  fileprivate struct Metric {
    static let tabBarHeight = 44.f
  }

  // MARK: Properties

  var disposeBag = DisposeBag()

  let reactor: Reactor

  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    reactor = dependency.reactor

    super.init(nibName: nil, bundle: nil)

    let viewController = UIViewController()

    let postItem = TabBarItem(title: "Temp",
                              viewController: viewController,
                              image: UIImage())

    let tabBarItems = [postItem]

    viewControllers = tabBarItems.map { tabBarItem -> UINavigationController in
      let navigationController = UINavigationController(
        rootViewController: tabBarItem.viewController
      )
      navigationController.isNavigationBarHidden = true
      navigationController.tabBarItem.title = tabBarItem.title
      navigationController.tabBarItem.image = tabBarItem.image
      navigationController.tabBarItem.imageInsets.top = 5
      navigationController.tabBarItem.imageInsets.bottom = -5
      return navigationController
    }

    view.backgroundColor = .red
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

//    if #available(iOS 11.0, *) {
//      self.tabBar.height = Metric.tabBarHeight + self.view.safeAreaInsets.bottom
//    } else {
//      self.tabBar.height = Metric.tabBarHeight
//    }
  }

  // MARK: Configuring

  func bind(reactor: MainTabBarViewReactor) {
    rx.didSelect
        .scan((nil, nil)) { state, viewController in (state.1, viewController) }
        // if select the view controller first time or select the same view controller again
        .filter { state in state.0 == nil || state.0 === state.1 }
        .map { state in state.1 }
        .filterNil()
        .subscribe(onNext: { [weak self] viewController in
          self?.scrollToTop(viewController) // scroll to top
        })
        .disposed(by: disposeBag)
  }

  func scrollToTop(_ viewController: UIViewController) {
    if let navigationController = viewController as? UINavigationController {
      let topViewController = navigationController.topViewController
      let firstViewController = navigationController.viewControllers.first
      if let viewController = topViewController, topViewController === firstViewController {
        scrollToTop(viewController)
      }
      return
    }
    guard let scrollView = viewController.view.subviews.first as? UIScrollView else {
      return
    }
    scrollView.setContentOffset(.zero, animated: true)
  }
}
