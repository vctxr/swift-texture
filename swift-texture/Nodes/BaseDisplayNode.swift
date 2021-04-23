//
//  BaseDisplayNode.swift
//  swift-texture
//
//  Created by Victor Samuel Cuaca on 23/04/21.
//

import AsyncDisplayKit

class BaseDisplayNode: ASDisplayNode {
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
    }
}

