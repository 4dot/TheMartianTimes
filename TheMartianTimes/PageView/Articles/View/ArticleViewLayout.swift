//
//  ArticleViewLayout.swift
//  TheMartianTimes
//
//  Created by Chanick on 6/26/21.
//

import UIKit


protocol ArticleViewLayoutDelegate: AnyObject {
    // Get Height For IndexPath
    func collectionView(_ collectionView: UICollectionView, heightForIndexPath indexPath: IndexPath , cellWidth: CGFloat ) -> CGFloat
}


class ArticleViewLayout: UICollectionViewLayout {
    
    weak var delegate: ArticleViewLayoutDelegate?
    
    private let cellPadding: CGFloat = 6
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
          return 0
        }
            
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
  
    override func prepare() {
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
    
        var yOffset: CGFloat = 0
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            // 28px: Inset of content cell
            let cellHeight = delegate?.collectionView( collectionView,
                                                       heightForIndexPath: indexPath ,
                                                       cellWidth: contentWidth - 28) ?? 180
            
            let height = cellPadding * 2 + cellHeight
            let frame = CGRect(x: 0,y: yOffset, width: contentWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)

            contentHeight = max(contentHeight, frame.maxY)
            yOffset = yOffset + height
        }
    }
    
  
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []

        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
//    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
//        super.invalidateLayout(with: context)
//
//        // Remove Cache
//        cache = []
//    }
}
