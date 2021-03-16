//
// Created by bongzniak on 2021/03/15.
//

import Foundation

import Pure
import AsyncDisplayKit
import RxSwift
import RxCocoa_Texture

final class CodeListSectionController: BaseASListSectionController<Code>, FactoryModule {

  typealias Node = CodeListSectionController

  // MARK: Dependency

  struct Dependency {
    let codeListViewCellNodeFactory: CodeListViewCellNode.Factory
  }

  struct Payload {
    let groupCodeType: GroupCodeType
    let code: Code
  }

  // MARK: Constants

  // MARK: Properties

  private let selectCodeSubject = PublishSubject<(
    groupCodeType: GroupCodeType,
    code: Code
  )>()
  var selectedCode: Observable<(groupCodeType: GroupCodeType, code: Code)> {
    selectCodeSubject.asObservable()
  }

  let cell: CodeListViewCellNode

  // MARK: Node

  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    cell = dependency.codeListViewCellNodeFactory.create(
      payload: .init(groupCodeType: payload.groupCodeType, code: payload.code)
    )

    super.init()

    cell.selectedCode
      .subscribe(onNext: { [weak self] (groupCodeType, code) in
        self?.selectCodeSubject.onNext((groupCodeType, code))
      })
      .disposed(by: disposeBag)
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    selectCodeSubject.onCompleted()
  }

  // MARK: Configuring

  // MARK: ASSectionController

  override func nodeForItem(at index: Int) -> ASCellNode {
    cell
  }

  override func didSelectItem(at index: Int) {
    super.didSelectItem(at: index)

    guard let code = object
    else {
      return
    }
  }
}
