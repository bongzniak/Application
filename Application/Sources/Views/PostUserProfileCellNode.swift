//
// Created by bongzniak on 2021/03/01.
//

import AsyncDisplayKit
import BonMot

class PostUserProfileCellNode: BaseCellNode {

  lazy var profileImageNode = ASDisplayNode().then {
    $0.style.preferredSize = .init(width: 50.f, height: 50.f)
    $0.backgroundColor = .red
  }
  lazy var nicknameNode = ASTextNode()
  lazy var datetimeNode = ASTextNode()

  override init() {
    super.init()
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    var children: [ASLayoutElement] = []
    let spec = ASStackLayoutSpec.horizontal()
    let spacer = ASLayoutSpec().then {
      $0.style.grow(1.f)
    }

    spec.style.width = ASDimension(unit: .points, value: 375.f)

    let style: StringStyle = StringStyle(
      .font(UIFont.systemFont(ofSize: 10.f))
    )
    nicknameNode.attributedText = "test".styled(with: style)
    datetimeNode.attributedText = "Today".styled(with: style)

    children.append(profileImageNode)
    children.append(nicknameNode)
    children.append(spacer)
    children.append(datetimeNode)

    spec.children = children

    return spec
  }
}
