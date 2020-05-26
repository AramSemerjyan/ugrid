//
//  GridSize.swift
//  UDifferentSizeGridView
//
//  Created by Aram Semerjyan on 5/21/20.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

class GridSize {

    enum SizeType: String {
        case small = "grid_size_small"
        case middle = "grid_size_middle"
        case big = "grid_size_big"

        mutating func toggole() {
            if self == .big {
                self = .small
            } else if self == .small {
                self = .middle
            } else {
                self = .big
            }
        }
    }

    private var _layoutType: LayoutType
    private var _layout: ILayoutScreen

    init(gridType: LayoutType, layoutScreen: ILayoutScreen) {
        _layoutType = gridType
        _layout = layoutScreen
    }

    private func itemsInRow(forSize size: SizeType) -> CGFloat {
        switch _layoutType {
        case .less:
            switch size {
            case .small:
                return 4
            case .middle:
                return 2
            case .big:
                return 1
            }
        case .more:
            switch size {
            case .small:
                return 6
            case .middle:
                return 3
            case .big:
                return 1
            }
        }
    }

    private func size(forCount count: CGFloat) -> CGSize {
        let layout = _layout.layoutWidth - (count + 1) * _layout.inset.left
        let itemWidth = layout / count

        return .init(width: itemWidth, height: itemWidth)
    }

    private func getItemWidth(forGridSize size: SizeType) -> CGFloat {
        let count = itemsInRow(forSize: size)
        let layout = _layout.layoutWidth - (count + 1) * _layout.inset.left

        return layout / count
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
