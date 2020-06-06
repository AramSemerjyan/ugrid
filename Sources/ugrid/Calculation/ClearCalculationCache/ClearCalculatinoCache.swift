//
//  ClearCalculatinoCache.swift
//  ugrid
//
//  Created by Aram Semerjyan on 5/30/20.
//

import UIKit

// TODO: maybe it'll be possible to get rid of the GridSize coupling
class ClearCompleteRow {
    private(set) var gridSize: IGridSize

    init(gridSize: IGridSize) {
        self.gridSize = gridSize
    }
}

final class ClearVerticalCompleteRow: ClearCompleteRow { }

extension ClearVerticalCompleteRow: IGridCompleteRowFinder {
    func findCompleteRows(inAttributes attributes: [UICollectionViewLayoutAttributes], completion: @escaping (CGFloat) -> Void) {
        let itemsCount = gridSize.countInRow(forItems: .small)
        let suffix = attributes.suffix(itemsCount)

        if suffix.count == itemsCount {
            let maxY = suffix.sorted { $0.frame.maxY > $1.frame.maxY }.first?.frame.maxY ?? 0
            let minY = suffix.sorted { $0.frame.maxY < $1.frame.maxY }.first?.frame.maxY ?? 0

            if minY == maxY {
                completion(maxY)
            }
        }
    }
}

final class ClearHorizontalCompleteRow: ClearCompleteRow { }

extension ClearHorizontalCompleteRow: IGridCompleteRowFinder {
    func findCompleteRows(inAttributes attributes: [UICollectionViewLayoutAttributes], completion: @escaping (CGFloat) -> Void) {
        let itemsCount = gridSize.countInRow(forItems: .small)
        let suffix = attributes.suffix(itemsCount)

        if suffix.count == itemsCount {
            let maxX = suffix.sorted { $0.frame.maxX > $1.frame.maxX }.first?.frame.maxX ?? 0
            let minX = suffix.sorted { $0.frame.maxX < $1.frame.maxX }.first?.frame.maxX ?? 0

            if minX == maxX {
                completion(maxX)
            }
        }
    }
}
