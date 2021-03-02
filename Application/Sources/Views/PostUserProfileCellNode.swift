//
// Created by bongzniak on 2021/03/01.
//

import ReactorKit
import Pure
import AsyncDisplayKit
import BonMot

final class PostUserProfileCellNode: BaseCellNode, FactoryModule, View {

  typealias Node = PostUserProfileCellNode
  typealias Reactor = PostUserProfileCellReactor

  // MARK: Dependency

  struct Dependency {
    let reactorFactory: (_ user: UserViewModel) -> Reactor
  }

  struct Payload {
    let user: UserViewModel
  }

  // MARK: Constants

  enum Metric {
    static let wrapperInset: UIEdgeInsets = .init(verticalInset: 10.f, horizontalInset: 16.f)
    static let profileImageSize: CGSize = .init(width: 25.f, height: 25.f)
    static let profileImageCornerRadius: CGFloat = 12.5
    static let optionButtonNodeSize: CGSize = .init(width: 44.f, height: 44.f)
  }

  enum Attribute {
    static let nicknameAttributes = StringStyle(.font(UIFont.boldSystemFont(ofSize: 12.f)))
  }

  // MARK: Properties

  // MARK: Node

  lazy var profileImageNode = ASNetworkImageNode().then {
    $0.style.preferredSize = Metric.profileImageSize
    $0.cornerRadius = Metric.profileImageCornerRadius
    $0.clipsToBounds = true
  }

  lazy var nicknameTextNode = BaseASTextNode()

  lazy var optionButtonNode = ASButtonNode().then {
    $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
    $0.style.preferredSize = Metric.optionButtonNodeSize
  }

  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    defer {
      reactor = dependency.reactorFactory(payload.user)
    }

    super.init()
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Configuring

  func bind(reactor: Reactor) {
    reactor.state.map {
        $0.profileUrl
      }
      .bind(to: profileImageNode.rx.url, setNeedsLayout: self)
      .disposed(by: disposeBag)

    reactor.state.map {
        $0.nickname
      }
      .bind(to: nicknameTextNode.rx.text(Attribute.nicknameAttributes.attributes),
            setNeedsLayout: self)
      .disposed(by: disposeBag)
  }

  // MARK: Layout Spec

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let spec = wrapperLayoutSpec()

    return ASInsetLayoutSpec(
      insets: Metric.wrapperInset,
      child: spec
    )
  }
}

// MARK : Layout Spec

extension PostUserProfileCellNode {

  private func wrapperLayoutSpec() -> ASLayoutSpec {

    profileImageNode.style.grow(0.f)
    nicknameTextNode.style.grow(1.f)
    optionButtonNode.style.grow(1.f)

    return ASStackLayoutSpec(
      direction: .horizontal,
      spacing: 10.f,
      justifyContent: .start,
      alignItems: .center,
      children: [profileImageNode, nicknameTextNode, optionButtonNode]
    )
  }
}
