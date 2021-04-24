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
        return viewModel.numberOfGIFs
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        guard viewModel.numberOfGIFs > indexPath.row else { return { ASCellNode() } }

        let gif = viewModel.gif(at: indexPath)
        return { GIFCellNode(gif: gif) }
    }
        
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> ASCellNode {
        return LoadingCellNode()
    }
}

// MARK: - ASCollectionDelegate
extension SearchGIFDataSource: ASCollectionDelegate, ASCollectionDelegateFlowLayout {
    
    func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
        return viewModel.shouldFetchMoreValue && !viewModel.isLoadingValue
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {      
        viewModel.fetchNewBatch {
            context.completeBatchFetching(true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        
        // iOS bug when tapping status bar (scroll to top gesture) then tapping search bar will result in scroll offset not properly calculated. This line makes sure that when that gesture is performed, the scroll content offset is calculated properly.

        guard offset.y == (viewModel.initialScrollOffset + 2) && !scrollView.isTracking else { return }
        scrollView.setContentOffset(CGPoint(x: offset.x, y: viewModel.initialScrollOffset), animated: true)
    }
}

// MARK: - AdaptiveCollectionViewLayout
extension SearchGIFDataSource: AdaptiveCollectionViewLayoutDelegate {
    
    func heightForItem(at indexPath: IndexPath) -> CGFloat {
        let height = viewModel.gif(at: indexPath).imageHeight
        return CGFloat(height)
    }
}
