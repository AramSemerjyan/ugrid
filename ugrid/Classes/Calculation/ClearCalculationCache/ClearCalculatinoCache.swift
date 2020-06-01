//
//  ClearCalculatinoCache.swift
//  ugrid
//
//  Created by Aram Semerjyan on 5/30/20.
//

import UIKit

class ClearCompleteRow {
    private(set) var layout: ILayoutScreen
    private(set) var gridSize: IGridSize

    init(_ layout: ILayoutScreen, gridSize: IGridSize) {
        self.layout = layout
        self.gridSize = gridSize
    }
}

class ClearVerticalCompleteRow: ClearCompleteRow { }

extension ClearVerticalCompleteRow: IGridCompleteRowFinder {
    func findCompleteRows(inAttributes attributes: [UICollectionViewLayoutAttributes], beforeFrame frame: CGRect, completion: @escaping (CGFloat) -> Void) {
        if (frame.maxX + gridSize.smallGrid.width) >= (layout.layoutWidth - layout.inset.left) {
            let height = attributes.sorted { $0.frame.maxY > $1.frame.maxY }.first?.frame.maxY ?? 0

            // Check that heigh for all items in the line is same
            // if it's not, that means that there can be an empy space to place new item
            if height == frame.maxY {
                completion(height)
            }
        }
    }
}

class ClearHorizontalCompleteRow: ClearCompleteRow { }

extension ClearHorizontalCompleteRow: IGridCompleteRowFinder {
    func findCompleteRows(inAttributes attributes: [UICollectionViewLayoutAttributes], beforeFrame frame: CGRect, completion: @escaping (CGFloat) -> Void) {
        if (frame.maxY + gridSize.smallGrid.height) >= (layout.layoutHeight - layout.inset.left) {
            let width = attributes.sorted { $0.frame.maxX > $1.frame.maxX }.first?.frame.maxX ?? 0

            // Check that heigh for all items in the line is same
            // if it's not, that means that there can be an empy space to place new item
            if width == frame.maxX {
                completion(width)
            }
        }
    }
}
