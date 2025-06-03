//
//  CenteredCollectionViewFlowLayout.swift
//  Ovulation
//
//  Created by Admin on 16/10/23.
//

import Foundation
import UIKit

class CenteredCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }

        let collectionViewSize = collectionView.bounds.size
        let halfWidth = collectionViewSize.width * 0.5
        let proposedContentOffsetCenterX = proposedContentOffset.x + halfWidth

        if let closestIndexPath = collectionView.indexPathForItem(at: CGPoint(x: proposedContentOffsetCenterX, y: collectionViewSize.height * 0.5)) {
            if let attributes = layoutAttributesForItem(at: closestIndexPath) {
                let centerX = attributes.center.x
                return CGPoint(x: centerX - halfWidth, y: proposedContentOffset.y)
            }
        }

        return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }

        guard let collectionView = collectionView, let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes] else {
            return superAttributes
        }

        let centerX = collectionView.contentOffset.x + collectionView.bounds.size.width / 2.0

        for item in attributes {
            let distance = abs(item.center.x - centerX)
            let scale = min(1, max(0.7, 1 - distance / 500))
            item.transform = CGAffineTransform(scaleX: scale, y: scale)
        }

        return attributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
    }
}

