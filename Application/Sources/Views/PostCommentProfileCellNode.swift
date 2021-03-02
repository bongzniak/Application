//
// Created by bongzniak on 2021/03/01.
//

import Pure
import ReactorKit
import AsyncDisplayKit
import BonMot
import TextureSwiftSupport

final class PostCommentProfileCellNode: BaseCellNode, FactoryModule, View {

  typealias Node = PostCommentProfileCellNode
  typealias Reactor = PostCommentProfileCellReactor

  // MARK: Dependency

  struct Dependency {
    let reactorFactory: (_ comment: CommentViewModel) -> Reactor
  }

  struct Payload {
    let comment: CommentViewModel
  }

  // MARK: - Constants

  enum Image {
    static let unlike = UIImage(systemName: "suit.heart.fill")
    static let like = UIImage(systemName: "suit.heart")
  }

  enum Attribute {
    static let nicknameAttributes = StringStyle(.font(UIFont.boldSystemFont(ofSize: 12.f)))
    static let contentsAttributes = StringStyle(.font(UIFont.systemFont(ofSize: 12.f)))
    static let datetimeAttributes = StringStyle(.font(UIFont.systemFont(ofSize: 10.f)))
    static let replyAttributes = StringStyle(.font(UIFont.systemFont(ofSize: 10.f)))
  }

  // MARK: - Node

  lazy var profileImageNode = ASNetworkImageNode().then {
    $0.style.preferredSize = .init(width: 30.f, height: 30.f)
    $0.backgroundColor = .red
    $0.cornerRadius = 15.f
    $0.clipsToBounds = true
    $0.style.flexShrink = 1.0
    $0.style.flexGrow = 0.0
  }
  lazy var nicknameNode = BaseASTextNode().then {
    $0.style.flexGrow = 1.0
  }
  lazy var datetimeNode = BaseASTextNode()

  lazy var replyNode = ASButtonNode()
  lazy var likeNode = ASButtonNode()

  // MARK: - Initializing

  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    defer {
      reactor = dependency.reactorFactory(payload.comment)
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
      .bind(to: profileImageNode.rx.url)
      .disposed(by: disposeBag)

    reactor.state.map {
        NSMutableAttributedString()
          .append(attributeString: $0.nickname.styled(with: Attribute.nicknameAttributes))
          .append(attributeString: " ".styled(with: Attribute.contentsAttributes))
          .append(attributeString: $0.contents.styled(with: Attribute.contentsAttributes))
      }
      .bind(to: nicknameNode.rx.attributedText, setNeedsLayout: self)
      .disposed(by: disposeBag)
  }

  // MARK: - Layout Spec

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    wrapperLayoutSpec()
  }
}

// MARK: - Layout Spec

extension PostCommentProfileCellNode {

  func wrapperLayoutSpec() -> ASLayoutSpec {
    let contentLayout = contentLayoutSpec()

    likeNode.setImage(Image.like, for: .normal)
    let likeLayout = ASCenterLayoutSpec(child: likeNode).then {
      $0.style.flexShrink = 1.0
      $0.style.flexGrow = 0.0
    }

    let stackLayout = ASStackLayoutSpec(
      direction: .horizontal,
      spacing: 10.0,
      justifyContent: .spaceBetween,
      alignItems: .stretch,
      children: [profileImageNode, contentLayout, likeLayout]
    )

    return ASInsetLayoutSpec(
      insets: .init(verticalInset: 10.f, horizontalInset: 16.f),
      child: stackLayout
    )
  }

  func contentLayoutSpec() -> ASLayoutSpec {
    let nicknameLayout = nicknameLayoutSpec()
    let infomationLayout = informationLayoutSpec()
    let elements = [nicknameLayout, infomationLayout]

    return ASStackLayoutSpec(
      direction: .vertical,
      spacing: 5.f,
      justifyContent: .spaceBetween,
      alignItems: .notSet,
      children: elements
    ).then {
      $0.style.flexShrink = 1.0
      $0.style.flexGrow = 1.0
    }
  }

  func nicknameLayoutSpec() -> ASLayoutSpec {
    ASStackLayoutSpec(
      direction: .horizontal,
      spacing: 10.0,
      justifyContent: .start,
      alignItems: .start,
      children: [nicknameNode]
    )
  }

  func informationLayoutSpec() -> ASLayoutSpec {
    datetimeNode.attributedText = "12시간".styled(with: Attribute.datetimeAttributes)
    replyNode.setAttributedTitle("답글 달기".styled(with: Attribute.replyAttributes), for: .normal)
    replyNode.style.spacingBefore = 15.f

    return ASStackLayoutSpec(
      direction: .horizontal,
      spacing: 10.0,
      justifyContent: .start,
      alignItems: .start,
      children: [datetimeNode, replyNode]
    )
  }
}
