//
//  POMCollectionViewFlowLayout.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/21.
//  Copyright © 2018年 Annie. All rights reserved.
//

import Foundation
import UIKit

class POMCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var offsetAdjustment = MAXFLOAT
        var horizontalOffset = proposedContentOffset.x + (self.collectionView!.bounds.size.width - self.itemSize.width) / 2.0
        var targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: self.collectionView!.bounds.size.width, height: self.collectionView!.bounds.size.height)

        var array = super.layoutAttributesForElements(in: targetRect)

        for layoutAttributes in array! {
            var itemOffset = layoutAttributes.frame.origin.x
            if (fabsf(Float(itemOffset - horizontalOffset)) < fabsf(offsetAdjustment)) {
                offsetAdjustment = Float(itemOffset - horizontalOffset)
            }
        }

        var offsetX = Float(proposedContentOffset.x) + offsetAdjustment
        return CGPoint(x: CGFloat(offsetX), y: proposedContentOffset.y)

    }
}
