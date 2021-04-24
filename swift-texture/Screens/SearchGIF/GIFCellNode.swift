//
//  GIFCellNode.swift
//  swift-texture
//
//  Created by Victor Samuel Cuaca on 23/04/21.
//

import AsyncDisplayKit

final class GIFCellNode: BaseCellNode {
    
    let imageNode = ASNetworkImageNode()
    
    init(gif: GIF) {
        super.init()
        cornerRadius = 8
        imageNode.url = URL(string: gif.urlString)
        imageNode.backgroundColor = .systemFill
        imageNode.delegate = self
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASWrapperLayoutSpec(layoutElement: imageNode)
    }

    override func layoutDidFinish() {
        super.layoutDidFinish()
        self.layer.startShimmering()
    }
}

// MARK: - ASNetworkImageNodeDelegate
extension GIFCellNode: ASNetworkImageNodeDelegate {
    
    func imageNodeDidLoadImage(fromCache imageNode: ASNetworkImageNode) {
        self.layer.stopShimmering()
    }
}
