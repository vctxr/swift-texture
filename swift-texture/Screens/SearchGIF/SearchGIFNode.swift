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
        let layout = AdaptiveCollectionViewLayout(numberOfColumns: 2, cellPadding: 12)
        layout.footerReferenceSize.height = 40
        
        collectionNode = ASCollectionNode(collectionViewLayout: layout)
        collectionNode.contentInset = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        collectionNode.registerSupplementaryNode(ofKind: UICollectionView.elementKindSectionFooter)
        collectionNode.alwaysBounceVertical = true
        
        super.init()
        backgroundColor = .systemBackground
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASWrapperLayoutSpec(layoutElements: [collectionNode, searchNotFoundNode])
    }
}
