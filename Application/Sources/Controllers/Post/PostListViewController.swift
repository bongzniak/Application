//
//  PostListViewController.swift
//  Application
//
//  Created by bongzniak on 2021/02/27.
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

final class PostListViewController: BaseViewController, FactoryModule, View {

  typealias Node = PostListViewController
  typealias Reactor = PostListViewReactor

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
    rx.viewDidLoad
      .subscribe(onNext: { [weak self] _ in
        let searchItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"))
        self?.navigationItem.leftBarButtonItem = searchItem

        let envelopeItem = UIBarButtonItem(image: UIImage(systemName: "envelope.open"))
        let calendarItem = UIBarButtonItem(image: UIImage(systemName: "calendar"))
        let bellItem = UIBarButtonItem(image: UIImage(systemName: "bell"))
        let personItem = UIBarButtonItem(image: UIImage(systemName: "person.circle"))
        self?.navigationItem.rightBarButtonItems = [
          personItem, bellItem, calendarItem, envelopeItem
        ]
      })
      .disposed(by: self.disposeBag)
  }

  // MARK: Layout Spec

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    ASInsetLayoutSpec(insets: view.safeAreaInsets,
                      child: ASLayoutSpec())
  }
}
