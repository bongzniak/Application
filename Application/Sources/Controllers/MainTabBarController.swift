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
  let image: UIImage?
  let viewController: UIViewController
}

final class MainTabBarController: UITabBarController, View, FactoryModule {

  typealias Node = MainTabBarController
  typealias Reactor = MainTabBarViewReactor

  // MARK: Dependency

  struct Dependency {
    let reactor: MainTabBarViewReactor
    let postListViewControllerFactory: PostListViewController.Factory
  }

  // MARK: Constants

  fileprivate struct Metric {
    static let tabBarHeight = 44.f
  }

  // MARK: Properties

  var disposeBag = DisposeBag()
  let postListViewControllerFactory: PostListViewController.Factory

  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    defer {
      reactor = dependency.reactor
    }
    postListViewControllerFactory = dependency.postListViewControllerFactory

    super.init(nibName: nil, bundle: nil)


  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    configureViewControllers()
  }

  // MARK: Configuring

  func bind(reactor: MainTabBarViewReactor) {
    rx.didSelect
      .scan((nil, nil)) { state, viewController in
        (state.1, viewController)
      }
      // if select the view controller first time or select the same view controller again
      .filter { state in
        state.0 == nil || state.0 === state.1
      }
      .map { state in
        state.1
      }
      .filterNil()
      .subscribe(onNext: { [weak self] viewController in
        self?.scrollToTop(viewController) // scroll to top
      })
      .disposed(by: disposeBag)
  }

  private func configureViewControllers() {
    let postTabbarItem = TabBarItem(
      title: "Post",
      image: UIImage(systemName: "house"),
      viewController: postListViewControllerFactory.create()
    )

    let tabBarItems = [postTabbarItem]
    viewControllers = tabBarItems.map { tabBarItem -> UINavigationController in
      UINavigationController(rootViewController: tabBarItem.viewController).then {
//        $0.navigationBar.prefersLargeTitles = true
//        $0.isNavigationBarHidden = true
        $0.tabBarItem.title = tabBarItem.title
        $0.tabBarItem.image = tabBarItem.image
        $0.tabBarItem.imageInsets.top = 5
        $0.tabBarItem.imageInsets.bottom = -5
      }
    }
  }

  // MARK: - Private func

  private func scrollToTop(_ viewController: UIViewController) {
    if let navigationController = viewController as? UINavigationController {
      let topViewController = navigationController.topViewController
      let firstViewController = navigationController.viewControllers.first
      if let viewController = topViewController, topViewController === firstViewController {
        scrollToTop(viewController)
      }
      return
    }
    guard let scrollView = viewController.view.subviews.first as? UIScrollView
    else {
      return
    }
    scrollView.setContentOffset(.zero, animated: true)
  }
}

extension MainTabBarController {

}
