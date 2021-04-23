//
//  SearchGIFNode.swift
//  swift-texture
//
//  Created by Victor Samuel Cuaca on 23/04/21.
//

import AsyncDisplayKit

final class SearchGIFNode: BaseDisplayNode {
    
    let collectionNode: ASCollectionNode
    let searchNotFoundNode = SearchNotFoundNode()
        
    var collectionNodeLayout: AdaptiveCollectionViewLayout? {
        collectionNode.collectionViewLayout as? AdaptiveCollectionViewLayout
    }
    
    override init() {
        let flowLayout = AdaptiveCollectionViewLayout(numberOfColumns: 2, cellPadding: 15)
        collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        collectionNode.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        super.init()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASWrapperLayoutSpec(layoutElements: [collectionNode, searchNotFoundNode])
    }
}
