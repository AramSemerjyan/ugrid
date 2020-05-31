//
//  GridSize.swift
//  UDifferentSizeGridView
//
//  Created by Aram Semerjyan on 5/21/20.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

class GridSize {
    private var _layoutType: LayoutType
    private var _layout: ILayout
    private var _gridInRow: IGridItemsInRow

    init(gridType: LayoutType, layout: ILayout, gridInRow: IGridItemsInRow) {
        _layoutType = gridType
        _layout = layout
        _gridInRow = gridInRow
    }

    private var row: CGFloat {
        _layout.scrollingDirection == .vertical ? _layout.layoutWidth : _layout.layoutHeight
    }

    private func size(forCount count: CGFloat) -> CGSize {
        let layout = row - (count + 1) * _layout.inset.left
        var itemWidth = layout / count

        itemWidth = (itemWidth*100).rounded()/100

        return .init(width: itemWidth, height: itemWidth)
    }

    private func getItemWidth(forGridSize size: SizeType) -> CGFloat {
        let count = _gridInRow.itemsInRow(forSizeType: size, andLayoutType: _layoutType)
        let layout = row - (count + 1) * _layout.inset.left
        let itemWidth = ((layout / count) * 100).rounded()/100

        return itemWidth
    }
}

extension GridSize: IGridSize {
    func setType(_ layoutType: LayoutType) {
        _layoutType = layoutType
    }

    func getSize(forGridSizeType sizeType: SizeType) -> CGSize {
        switch sizeType {
        case .small:
            return smallGrid
        case .middle:
            return middleGrid
        case .big:
            return bigGrid
        }
    }

    var smallGrid: CGSize {
        let itemWidth = getItemWidth(forGridSize: .small)

        return .init(width: itemWidth, height: itemWidth)
    }

    var middleGrid: CGSize {
        let itemWidth = getItemWidth(forGridSize: .middle)

        return .init(width: itemWidth, height: itemWidth)
    }

    var bigGrid: CGSize {
        let itemWidth = getItemWidth(forGridSize: .big)

        switch _layoutType {
        case .less:
            return .init(width: itemWidth, height: middleGrid.height)
        case .more:
            return .init(width: itemWidth * 6 / 9.1, height: middleGrid.height)
        }
    }
}

extension GridSize: IGridSizeConfigurable {
    func setGirdItemsInRow(_ itemsInRow: IGridItemsInRow) {
        _gridInRow = itemsInRow
    }
}
