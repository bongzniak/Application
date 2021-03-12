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
import TextureSwiftSupport
import URLNavigator
import IGListKit
import RxIGListKit

final class JournalListViewController: BaseViewController, FactoryModule, View {

  typealias Node = JournalListViewController
  typealias Reactor = JournalListViewReactor

  // MARK: Dependency

  struct Dependency {
    let navigator: NavigatorType
    let reactor: Reactor
    let journalModifyViewControllerFactory: JournalModifyViewController.Factory
    let postListSectionControllerFactory: JournalListSectionController.Factory
  }

  // MARK: Constants

  enum Metric {
    static let buttonSize: CGSize = .init(width: 60.f, height: 60.f)
    static let buttonCornerRadius: CGFloat = 30.f
  }

  enum Image {
    static let buttonImage = UIImage.init(systemName: "note.text.badge.plus")
  }

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
  lazy var buttonNode = ASButtonNode().then {
    $0.style.preferredSize = Metric.buttonSize
    $0.setImage(Image.buttonImage, for: .normal)
    $0.cornerRadius = Metric.buttonCornerRadius
    $0.clipsToBounds = true
    $0.backgroundColor = .gray
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
      navigator: dependency.navigator,
      reactor: dependency.reactor,
      journalModifyViewControllerFactory: dependency.journalModifyViewControllerFactory,
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
    configureNavigationItem()
  }

  // MARK: Configuring

  func bind(reactor: Reactor) {

    // Action

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

    buttonNode.rx.tap
    .bind(onNext: { [weak self] in
      self?.buttonNodeDidTap()
    })
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

  override func configureNavigationItem() {
    super.configureNavigationItem()

    title = "Beer"
    navigationItem.largeTitleDisplayMode = .always
    navigationItem.leftBarButtonItem = nil
  }

  // MARK: Layout Spec

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    LayoutSpec {
      VStackLayout {
        [collectionNode]
      }
      RelativeLayout(horizontalPosition: .end, verticalPosition: .end) {
        InsetLayout(insets: self.view.safeAreaInsets) {
          buttonNode
        }
        .padding([.right, .bottom], 16.f)
      }
    }
  }
}

// MARK: Action Event

extension JournalListViewController {
  func buttonNodeDidTap() {
    let vc = dependency.journalModifyViewControllerFactory.create(payload: .init(id: nil))
    let navigation = UINavigationController(rootViewController: vc)
    navigation.modalPresentationStyle = .fullScreen
    dependency.navigator.present(navigation)
  }
}

// MARK: Layout Spec

extension JournalListViewController {
  private func makeWriteButtonNode() -> AnyDisplayNode {
    AnyDisplayNode { [unowned self] _, _ in
      LayoutSpec {
        RelativeLayout(horizontalPosition: .end, verticalPosition: .end) {
          buttonNode
        }
      }
    }
  }
}
