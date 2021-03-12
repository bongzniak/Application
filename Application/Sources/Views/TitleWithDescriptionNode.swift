//
// Created by bongzniak on 2021/03/06.
//

import Foundation

import AsyncDisplayKit
import TextureSwiftSupport
import BonMot

class TitleWithDescriptionNode: ASDisplayNode {

  // MARK: Constants

  enum Metric {
    static let spacing: CGFloat = 12.f
  }

  enum Style {
    static let name = StringStyle(
      .font(UIFont.boldSystemFont(ofSize: 24.f))
    )
    static let description = StringStyle(
      .font(UIFont.systemFont(ofSize: 17.f))
    )
  }

  // MARK: Node

  lazy var titleTextNode = BaseASTextNode()
  lazy var descriptionTextNode = BaseASTextNode()

  init(title: String, description: String) {
    super.init()

    automaticallyManagesSubnodes = true

    titleTextNode.attributedText = title.styled(with: Style.name)
    descriptionTextNode.attributedText = description.styled(
      with: Style.description
    )
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    LayoutSpec {
      VStackLayout(spacing: Metric.spacing) {
        titleTextNode
        descriptionTextNode
      }
    }
  }
}
