//
//  SearchNotFoundNode.swift
//  swift-texture
//
//  Created by Victor Samuel Cuaca on 23/04/21.
//

import AsyncDisplayKit

final class SearchNotFoundNode: BaseDisplayNode {
    
    let imageNode = ASImageNode()
    let textNode = ASTextNode()
    
    override init() {
        super.init()
        
        backgroundColor = .systemBackground
        imageNode.image = UIImage(named: "alert")
        textNode.attributedText = NSAttributedString(
            string: "Uh oh.. we couldn't find anything.\nTry checking your API key ✨🌈",
            attributes: [
                NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline),
                NSAttributedString.Key.foregroundColor: UIColor.label
            ]
        )
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASStackLayoutSpec(direction: .vertical,
                                 spacing: 8,
                                 justifyContent: .center,
                                 alignItems: .center,
                                 children: [imageNode, textNode])
    }
}

