//
// Created by bongzniak on 2021/03/03.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa_Texture
import TextureSwiftSupport
import BonMot

class ASImageWithTextNode: ASDisplayNode {

  // MARK: Constants

  fileprivate enum Metric {
    static let spacing = 4.f
  }

  fileprivate enum Style {
    static let text = StringStyle(
      .font(UIFont.systemFont(ofSize: 12.f))
    )
  }

  // MARK: Properties

  fileprivate let direction: ASStackLayoutDirection

  // MARK: Node

  fileprivate lazy var imageNode = ASImageNode()
  fileprivate lazy var networkImageNode = ASNetworkImageNode()
  fileprivate lazy var textNode = BaseASTextNode()

  // MARK: Initializing

  init(
    text: String,
    fontSize: CGFloat = 12.f,
    direction: ASStackLayoutDirection = .horizontal
  ) {
    self.direction = direction

    super.init()

    automaticallyManagesSubnodes = true

    let attributes = StringStyle(
      .font(UIFont.systemFont(ofSize: fontSize))
    )
    textNode.attributedText = text.styled(with: attributes)
  }

  convenience init(
    image: UIImage?,
    imageSize: CGSize? = nil,
    text: String,
    fontSize: CGFloat = 12.f,
    direction: ASStackLayoutDirection = .horizontal
  ) {
    self.init(text: text, fontSize: fontSize, direction: direction)

    imageNode.image = image
    if let imageSize = imageSize {
      imageNode.style.preferredSize = imageSize
    }
  }

  convenience init(
    imageURLString: String,
    imageSize: CGSize? = nil,
    text: String,
    fontSize: CGFloat = 12.f,
    direction: ASStackLayoutDirection = .horizontal
  ) {
    self.init(text: text, fontSize: fontSize, direction: direction)

    networkImageNode.url = URL(string: imageURLString)
    if let imageSize = imageSize {
      networkImageNode.style.preferredSize = imageSize
    }
  }

  // MARK: Layout Spec

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    var elements: [ASDisplayNode] = []

    if imageNode.image != nil {
      elements.append(imageNode)
    }

    if networkImageNode.url != nil {
      elements.append(networkImageNode)
    }

    if textNode.attributedText != nil {
      elements.append(textNode)
    }

    return LayoutSpec {
      HStackLayout(spacing: Metric.spacing) {
        elements
      }
    }
  }
}
