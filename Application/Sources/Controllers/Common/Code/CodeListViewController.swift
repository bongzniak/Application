//
//  CodeListViewController.swift
//  Application
//
//  Created by bongzniak on 2021/03/09.
//
//

import Foundation
import UIKit

import Pure
import ReactorKit
import AsyncDisplayKit
import TextureSwiftSupport
import RxSwift
import RxCocoa_Texture
import URLNavigator
import IGListKit
import RxIGListKit

protocol CodeListViewControllerDelegate: class {
  func selectedCode(groupCodeType: GroupCodeType, code: Code)
}

final class CodeListViewController: BaseViewController, FactoryModule, View {

  typealias Node = CodeListViewController
  typealias Reactor = CodeListViewReactor

  // MARK: Dependency

  struct Dependency {
    let reactorFactory: (GroupCodeType) -> Reactor
    let codeListSectionControllerFactory: CodeListSectionController.Factory
  }

  // MARK: Payload

  struct Payload {
    let groupCodeType: GroupCodeType
  }

  // MARK: Constants

  // MARK: Properties

  weak var delegate: CodeListViewControllerDelegate?
  let groupCodeType: GroupCodeType
  let codeListSectionControllerFactory: CodeListSectionController.Factory

  // MARK: Node

  let refreshControl = UIRefreshControl()
  lazy var collectionViewFlowLayout = UICollectionViewFlowLayout()
  lazy var collectionNode = ASCollectionNode(collectionViewLayout: collectionViewFlowLayout)

  let objectSignal = BehaviorSubject<[CommonListSection]>(value: [])
  lazy var dataSource = RxListAdapterDataSource<CommonListSection> {
    [unowned self] (_, section) -> ListSectionController in
    switch section {
    case let .codeListCell(code):
      let section = self.codeListSectionControllerFactory.create(
        payload: .init(groupCodeType: self.groupCodeType, code: code)
      )
      section.delegate = self
      return section
    }
  }

  lazy var adapter: ListAdapter = {
    ListAdapter(updater: ListAdapterUpdater(), viewController: self)
  }()

  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    defer { reactor = dependency.reactorFactory(payload.groupCodeType) }

    groupCodeType = payload.groupCodeType
    codeListSectionControllerFactory = dependency.codeListSectionControllerFactory

    super.init()

    adapter.setASDKCollectionNode(collectionNode)
    collectionNode.view.refreshControl = refreshControl
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Configuring

  func bind(reactor: Reactor) {

    // Action

    rx.viewDidLoad
      .map { Reactor.Action.refresh }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

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
      .bind(to: refreshControl.rx.isRefreshing)
      .disposed(by: disposeBag)

    objectSignal
      .bind(to: adapter.rx.objects(for: dataSource))
      .disposed(by: disposeBag)

    reactor.state.map {
        $0.sections
      }
      .bind { [weak self] sections in
        self?.objectSignal.onNext(sections)
      }
      .disposed(by: disposeBag)
  }

  // MARK: Layout Spec

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    LayoutSpec {
      WrapperLayout {
        collectionNode
      }
    }
  }
}

extension CodeListViewController: CodeListSectionControllerDelegate {
  func selectedCode(groupCodeType: GroupCodeType, code: Code) {
     delegate?.selectedCode(groupCodeType: groupCodeType, code: code)
  }
}
