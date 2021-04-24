//
//  LoadingCellNode.swift
//  swift-texture
//
//  Created by Victor Samuel Cuaca on 24/04/21.
//

import AsyncDisplayKit

final class LoadingCellNode: BaseCellNode {
    
    let activityIndicator = UIActivityIndicatorView()
    let containerNode = ASDisplayNode()
    
    override init() {
        super.init()
        containerNode.style.preferredSize = CGSize(width: 50, height: 50)
    }
    
    override func didLoad() {
        super.didLoad()
        
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        containerNode.view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: containerNode.view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerNode.view.centerYAnchor)
        ])
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: containerNode)
    }
}
