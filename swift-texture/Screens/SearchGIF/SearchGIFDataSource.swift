//
//  SearchGIFDataSource.swift
//  swift-texture
//
//  Created by Victor Samuel Cuaca on 23/04/21.
//

import AsyncDisplayKit

final class SearchGIFDataSource: NSObject {
    
    private var viewModel: SearchGIFVM!

    init(viewModel: SearchGIFVM) {
        self.viewModel = viewModel
    }
}

// MARK: - ASCollectionDataSource
extension SearchGIFDataSource: ASCollectionDataSource {
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return viewModel.gifs.value.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        guard viewModel.gifs.value.count > indexPath.row else { return { ASCellNode() } }

        let gif = viewModel.gifs.value[indexPath.row]
        return { GIFCellNode(gif: gif) }
    }
}

// MARK: - AdaptiveCollectionViewLayoutDelegate
extension SearchGIFDataSource: AdaptiveCollectionViewLayoutDelegate {
    
    func heightForItem(at indexPath: IndexPath) -> CGFloat {
        let height = viewModel.gifs.value[indexPath.row].imageHeight
        return CGFloat(height)
    }
}
