//
//  ZMInputCollectionView+Layout.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2023/10/15.
//  Copyright © 2023 ZM. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ZMInputCollectionViewLayoutV1
public class ZMInputCollectionViewLayoutV1: UICollectionViewFlowLayout {

    @objc public override dynamic func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        let attr = super.layoutAttributesForElements(in: rect)
        guard let collectionView = self.collectionView else {
            return attr
        }

        let cellAttrs = attr?.filter({ $0.representedElementCategory == UICollectionView.ElementCategory.cell }) ?? []
        var sectionDic: [Int:[UICollectionViewLayoutAttributes]] = [:]
        cellAttrs.forEach { attr in
            if var sectionAttrs = sectionDic[attr.indexPath.section] {
                sectionAttrs.append(attr)
                sectionDic[attr.indexPath.section] = sectionAttrs
            } else {
                sectionDic[attr.indexPath.section] = [attr]
            }
        }


        for group in sectionDic.values {
            var preItem: UICollectionViewLayoutAttributes?
            var sortedGroup = group.sorted { attr1, attr2 in
                attr1.indexPath.row <  attr2.indexPath.row
            }
            for item in sortedGroup {
                var frame = item.frame
                if preItem?.frame.minY == item.frame.minY {

                    var minimumInteritemSpacing: CGFloat = self.minimumInteritemSpacing
                    if let delegate = collectionView.delegate,
                       let flowDelegate = delegate as? UICollectionViewDelegateFlowLayout {
                        minimumInteritemSpacing = flowDelegate.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: item.indexPath.section) ?? minimumInteritemSpacing
                    }

                    frame.origin.x = (preItem?.frame.maxX ?? 0) + minimumInteritemSpacing
                    item.frame = frame
                } else {
                    item.frame = frame
                }
                preItem = item
            }
        }

        return attr
    }

    var oldBounds: CGRect?

    @objc public override dynamic func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if newBounds != oldBounds {
            oldBounds = newBounds
            return true
        }
        return false
    }
}
