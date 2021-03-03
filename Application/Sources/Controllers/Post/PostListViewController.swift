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

final class PostListViewController: BaseViewController, FactoryModule, View {

  typealias Node = PostListViewController
  typealias Reactor = PostListViewReactor

  // MARK: Dependency

  struct Dependency {
    let reactor: Reactor
    let postListBindingSectionControllerFactory: PostListBindingSectionController.Factory
  }

  // MARK: Constants

  // MARK: Properties

  let dependency: Dependency

  var posts: [Post] = []

  // MARK: Node

  let refreshControl = UIRefreshControl()
  lazy var collectionViewFlowLayout = UICollectionViewFlowLayout().then {
    $0.scrollDirection = .vertical
  }
  lazy var collectionNode = ASCollectionNode(collectionViewLayout: collectionViewFlowLayout).then {
    $0.style.flexGrow = 1.0
    $0.style.flexShrink = 1.0
  }

  let objectsSignal = BehaviorSubject<[PostListSection]>(value: [])
  lazy var dataSource = RxListAdapterDataSource<PostListSection>(
    sectionControllerProvider: { [weak self] (_, object) -> ListSectionController in
      guard let `self` = self
      else {
        return ListSectionController()
      }

      switch object {
      case .post(let post):
        return self.dependency.postListBindingSectionControllerFactory.create()
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
      postListBindingSectionControllerFactory: dependency.postListBindingSectionControllerFactory
    )

    super.init()

    adapter.setASDKCollectionNode(collectionNode)
    collectionNode.view.refreshControl = refreshControl
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
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

// MARK: - ASCollectionDataSource

extension PostListViewController: ASCollectionDelegate {
  func collectionNode(_ collectionNode: ASCollectionNode, willDisplayItemWith node: ASCellNode) {
    log.info("willDisplayItemWith")
  }
}
