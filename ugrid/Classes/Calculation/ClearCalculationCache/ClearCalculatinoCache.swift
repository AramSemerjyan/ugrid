//
//  ClearCalculatinoCache.swift
//  ugrid
//
//  Created by Aram Semerjyan on 5/30/20.
//

import UIKit

//class ClearCalculatinoCache: IGridCalculationClearCache {
//    func clearCacheForHorizontal() {
//
//    }
//
//    func clearCacheForVertical(attributes: inout [UICollectionViewLayoutAttributes],
//                               withItemHeight height: CGFloat,
//                               inLayout layout: ILayoutScreen,
//                               cleared: @escaping () -> ()
//    ) {
//        if frame.maxX == (layout.layoutWidth - layout.inset.left) {
//            let height = attributes.sorted { $0.frame.maxY > $1.frame.maxY }.first?.frame.maxY ?? 0
//
//            // Check that heigh for all items in the line is same
//            // if it's not, that means that there can be an empy space to place new item
//            if height == frame.maxY {
//                attributes.removeAll()
//
//                cleared()
//            }
//        }
//    }
//}
