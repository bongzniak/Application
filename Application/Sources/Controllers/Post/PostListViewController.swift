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
import IGListKit

final class PostListViewController: BaseViewController, FactoryModule, View {

  typealias Node = PostListViewController
  typealias Reactor = PostListViewReactor

  // MARK: Dependency

  struct Dependency {
    let reactor: Reactor
  }

  // MARK: Constants

  // MARK: Properties

  lazy var collectionViewFlowLayout = UICollectionViewFlowLayout().then {
    $0.scrollDirection = .vertical
  }

  lazy var collectionNode = ASCollectionNode(collectionViewLayout: collectionViewFlowLayout).then {
    $0.backgroundColor = .blue
  }

  lazy var adapter: ListAdapter = {
    ListAdapter(updater: ListAdapterUpdater(), viewController: self)
  }()

  // MARK: Node

  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    defer {
      reactor = dependency.reactor
    }

    super.init()

    adapter.setASDKCollectionNode(collectionNode)
    adapter.dataSource = self
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Configuring

  func bind(reactor: Reactor) {
    rx.viewDidLoad
      .subscribe(onNext: { [weak self] _ in
        self?.configureNavigationItem()
      })
      .disposed(by: self.disposeBag)
  }

  // MARK: Layout Spec

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    ASWrapperLayoutSpec(layoutElement: collectionNode)
  }
}

extension PostListViewController {
  // NavigationItem setting
  private func configureNavigationItem() {
    let searchItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"))
    navigationItem.leftBarButtonItem = searchItem

    let envelopeItem = UIBarButtonItem(image: UIImage(systemName: "envelope.open"))
    let calendarItem = UIBarButtonItem(image: UIImage(systemName: "calendar"))
    let bellItem = UIBarButtonItem(image: UIImage(systemName: "bell"))
    let personItem = UIBarButtonItem(image: UIImage(systemName: "person.circle"))
    navigationItem.rightBarButtonItems = [
      personItem, bellItem, calendarItem, envelopeItem
    ]
  }
}

// MARK: - ListAdapterDataSource

extension PostListViewController: ListAdapterDataSource {
  func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
    []
  }

  func listAdapter(
    _ listAdapter: ListAdapter,
    sectionControllerFor object: Any
  ) -> ListSectionController {
    PostListSectionController()
  }

  func emptyView(for listAdapter: ListAdapter) -> UIView? {
    nil
  }
}
