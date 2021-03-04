//
// Created by bongzniak on 2021/03/03.
//

import AsyncDisplayKit
import BonMot

class ImageWithTextNode: ASDisplayNode {

  // MARK: Constants

  enum Metric {
    static let spacing = 4.f
  }

  enum Attribute {
    static let textAttribute = StringStyle(
      .font(UIFont.systemFont(ofSize: 12.f))
    )
  }

  // MARK: Properties

  // MARK: Node

  lazy var imageNode = ASImageNode()
  lazy var textNode = BaseASTextNode()

  // MARK: Initializing

  init(image: UIImage?, text: String) {
    super.init()

    automaticallyManagesSubnodes = true

    imageNode.image = image
    textNode.attributedText = text.styled(with: Attribute.textAttribute)
  }

  // MARK: Layout Spec

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    ASStackLayoutSpec(
      direction: .horizontal,
      spacing: Metric.spacing,
      justifyContent: .start,
      alignItems: .center,
      children: [imageNode, textNode]
    )
  }
}
