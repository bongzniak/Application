//
// Created by bongzniak on 2021/03/15.
//

import Foundation

import Pure
import AsyncDisplayKit
import RxSwift
import RxCocoa_Texture

protocol CodeListSectionControllerDelegate: class {
  func selectedCode(groupCodeType: GroupCodeType, code: Code)
}

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

  weak var delegate: CodeListSectionControllerDelegate?
  let groupCodeType: GroupCodeType
  let code: Code

  let codeListViewCellNodeFactory: CodeListViewCellNode.Factory

  // MARK: Node

  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    groupCodeType = payload.groupCodeType
    code = payload.code

    codeListViewCellNodeFactory = dependency.codeListViewCellNodeFactory

    super.init()
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Configuring

  // MARK: ASSectionController

  override func nodeForItem(at index: Int) -> ASCellNode {
    let cell = codeListViewCellNodeFactory.create(
      payload: .init(groupCodeType: groupCodeType, code: code)
    )

    return cell
  }

  override func didSelectItem(at index: Int) {
    super.didSelectItem(at: index)

    guard let code = object
    else {
      return
    }

    delegate?.selectedCode(groupCodeType: groupCodeType, code: code)
  }
}
