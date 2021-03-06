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
import RxIGListKit

final class JournalListViewController: BaseViewController, FactoryModule, View {

  typealias Node = JournalListViewController
  typealias Reactor = JournalListViewReactor

  // MARK: Dependency

  struct Dependency {
    let reactor: Reactor
    let postListSectionControllerFactory: JournalListSectionController.Factory
  }

  // MARK: Constants

  // MARK: Properties

  let dependency: Dependency

  var posts: [Beer] = []

  // MARK: Node

  let refreshControl = UIRefreshControl()
  lazy var collectionViewFlowLayout = UICollectionViewFlowLayout().then {
    $0.scrollDirection = .vertical
  }
  lazy var collectionNode = ASCollectionNode(collectionViewLayout: collectionViewFlowLayout).then {
    $0.style.flexGrow = 1.0
    $0.style.flexShrink = 1.0
  }

  let objectsSignal = BehaviorSubject<[JournalListSection]>(value: [])
  lazy var dataSource = RxListAdapterDataSource<JournalListSection>(
    sectionControllerProvider: { [weak self] (_, object) -> ListSectionController in
      guard let `self` = self
      else {
        return ListSectionController()
      }

      switch object {
      case .post(let post):
        return self.dependency.postListSectionControllerFactory.create()
      }
    }
  )

  lazy var adapter: ListAdapter = {
    ListAdapter(updater: ListAdapterUpdater(), viewController: self)
  }()

  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    defer {
      reactor = dependency.reactor
    }
    self.dependency = Dependency(
      reactor: dependency.reactor,
      postListSectionControllerFactory: dependency.postListSectionControllerFactory
    )

    super.init()

    adapter.setASDKCollectionNode(collectionNode)
    collectionNode.view.refreshControl = refreshControl
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    hidesBottomBarWhenPushed = false
  }

  // MARK: Configuring

  func bind(reactor: Reactor) {

    // Action
    rx.viewDidLoad
      .subscribe(onNext: { [weak self] in
        self?.configureNavigationItem()
      })
      .disposed(by: disposeBag)

    rx.viewDidLoad
      .map {
        Reactor.Action.refresh
      }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    refreshControl.rx.controlEvent(.valueChanged)
      .map {
        Reactor.Action.refresh
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // State

    reactor.state.map {
        $0.isRefreshing
      }
      .distinctUntilChanged()
      .bind(to: refreshControl.rx.isRefreshing)
      .disposed(by: self.disposeBag)

    reactor.state.map {
        $0.isRefreshing
      }
      .bind(to: refreshControl.rx.isRefreshing)
      .disposed(by: disposeBag)

    objectsSignal
      .bind(to: adapter.rx.objects(for: dataSource))
      .disposed(by: disposeBag)

    reactor.state.map {
        $0.sections
      }
      .subscribe { [weak self] sections in
        self?.objectsSignal.onNext(sections)
      }
      .disposed(by: disposeBag)
  }

  // MARK: Layout Spec

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    ASWrapperLayoutSpec(layoutElement: collectionNode)
  }
}

extension JournalListViewController {
  // NavigationItem setting
  private func configureNavigationItem() {
    navigationItem.leftBarButtonItem = nil

    let envelopeItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"))
    let calendarItem = UIBarButtonItem(image: UIImage(systemName: "slider.vertical.3"))
    let bellItem = UIBarButtonItem(image: UIImage(systemName: "bell"))
    navigationItem.rightBarButtonItems = [
      bellItem, calendarItem, envelopeItem
    ]
  }
}

// MARK: - ASCollectionDataSource

extension JournalListViewController: ASCollectionDelegate {
  func collectionNode(_ collectionNode: ASCollectionNode, willDisplayItemWith node: ASCellNode) {
    log.info("willDisplayItemWith")
  }
}
