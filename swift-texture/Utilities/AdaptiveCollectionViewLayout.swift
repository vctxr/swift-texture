//
//  AdaptiveCollectionViewLayout.swift
//  swift-texture
//
//  Created by Victor Samuel Cuaca on 23/04/21.
//

import AsyncDisplayKit

protocol AdaptiveCollectionViewLayoutDelegate: AnyObject {
    func heightForItem(at indexPath: IndexPath) -> CGFloat
}

class AdaptiveCollectionViewLayout: UICollectionViewFlowLayout {
    
    weak var delegate: AdaptiveCollectionViewLayoutDelegate?
    
    private let numberOfColumns: Int
    private let cellPadding: CGFloat
    private var itemAttributes: [UICollectionViewLayoutAttributes] = []
    private var allAttributes: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    private var column = 0
    private var lastItemCount = 0
    private var xOffsets: [CGFloat] = []
    private var yOffsets: [CGFloat] = []
    
    private var collectionViewContentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width -
            (insets.left + insets.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right)
    }
    
    private var columnWidth: CGFloat {
        let totalHorizontalPadding = cellPadding * (CGFloat(numberOfColumns) - 1)
        return (collectionViewContentWidth - totalHorizontalPadding) / CGFloat(numberOfColumns)
    }
    
    init(numberOfColumns: Int, cellPadding: CGFloat) {
        self.numberOfColumns = numberOfColumns
        self.cellPadding = cellPadding
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var collectionViewContentSize: CGSize {
        CGSize(width: collectionViewContentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard let collectionView = collectionView,
              collectionView.numberOfSections > 0,
              lastItemCount < collectionView.numberOfItems(inSection: 0) else { return }
        
        // 1. Initialize the x and y offsets for the first time
        if itemAttributes.isEmpty {
            for column in 0..<numberOfColumns {
                xOffsets.append(CGFloat(column) * (columnWidth + cellPadding) + collectionView.safeAreaInsets.left)
            }
            yOffsets = [CGFloat](repeating: 0, count: numberOfColumns)
        }
        
        // 2. Iterates through the list of items from the last item count in the first section to save cpu power
        for item in lastItemCount..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
                                                
            // 3. Asks the delegate for the height of the picture and the annotation and calculates the cell frame.
            let itemHeight = delegate?.heightForItem(at: indexPath) ?? 0
            let cellHeight = itemHeight + (cellPadding * 2)
            let cellFrame = CGRect(x: xOffsets[column], y: yOffsets[column], width: columnWidth, height: cellHeight)
            
            // 4. Creates an UICollectionViewLayoutAttributes with the frame and add it to the cache
            let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            layoutAttributes.frame = cellFrame
            itemAttributes.append(layoutAttributes)
            allAttributes.append(layoutAttributes)
            
            // 5. Updates the collection view content height and the y offsets
            contentHeight = max(contentHeight, cellFrame.maxY)
            yOffsets[column] += (cellHeight + cellPadding)
            
            // 6. Adjust the next item to be in the column with the minimum y offset so the columns are always in balanced height
            if let minYOffset = yOffsets.min(), let minYIndex = yOffsets.firstIndex(of: minYOffset) {
                column = minYIndex
            } else {
                column = column < (numberOfColumns - 1) ? (column + 1) : 0
            }
        }
        
        lastItemCount = collectionView.numberOfItems(inSection: 0)
        
        // 7. Calculate the layout attributes for section footer
        guard footerReferenceSize.height > 0 else { return }

        let footerAttributes = UICollectionViewLayoutAttributes(
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            with: IndexPath(item: 0, section: 0)
        )
              
        footerAttributes.frame = CGRect(
            x: collectionView.safeAreaInsets.left,
            y: contentHeight + collectionView.contentInset.bottom,
            width: collectionViewContentWidth,
            height: footerReferenceSize.height
        )

        allAttributes.append(footerAttributes)
        contentHeight += footerReferenceSize.height
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // Loop through the cache and look for item intersecting the visible rect
        return allAttributes.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemAttributes[indexPath.item]
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        
        itemAttributes.removeAll()
        allAttributes.removeAll()
        xOffsets.removeAll()
        yOffsets.removeAll()
        contentHeight = 0
        lastItemCount = 0
        column = 0
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        !(collectionView?.bounds.size.equalTo(newBounds.size) ?? true)
    }
}
