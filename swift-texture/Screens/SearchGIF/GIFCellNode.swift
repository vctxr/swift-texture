//
//  GIFCellNode.swift
//  swift-texture
//
//  Created by Victor Samuel Cuaca on 23/04/21.
//

import AsyncDisplayKit

final class GIFCellNode: BaseCellNode {
    
    let imageNode = ASNetworkImageNode()
    let image = ASImageNode()
    
    init(gif: GIF) {
        super.init()
        imageNode.cornerRadius = 8
        imageNode.url = URL(string: gif.urlString)
        imageNode.backgroundColor = .systemFill
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASWrapperLayoutSpec(layoutElement: imageNode)
    }
}
