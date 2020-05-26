//
//  GridCalculationLogic.swift
//  UDifferentSizeGridView
//
//  Created by Aram Semerjyan on 5/18/20.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

class GridCalculationLogic: IGridCalculation {

    // MARK: - private vars
    private var _repo: IGridSizeRepository!
    private var _layout: ILayoutScreen!
    private var _gridSize: IGridSize!

    private var _furthestBlockRect: CGRect = .zero
    private var _contentSize: CGSize = .zero

    // MARK: - life cycle
    required init(_ layout: ILayoutScreen, gridSize: IGridSize) {
        _layout = layout
        _repo = GridSizeRepository()
        _gridSize = gridSize
    }

    // MARK: - protocol conformance
    var gridType: LayoutType = .less {
        willSet {
            _gridSize.setType(newValue)
        }
    }

    var furthestBlockRect: CGRect {
        return _furthestBlockRect
    }

    var contentSize: CGSize {
        return _contentSize
    }

    func setLayoutType(_ type: LayoutType) {
        _gridSize.setType(type)
    }

    func reset() {
        _furthestBlockRect = .zero
        _contentSize = .zero
    }

    @discardableResult
    func calculate(attributes: [UICollectionViewLayoutAttributes]?, withItemSizes sizes: [IndexPath: GridSize.SizeType]) -> [UICollectionViewLayoutAttributes]? {

        guard let attributes = attributes else { return nil }

        guard !attributes.isEmpty else { return attributes }

        var attributesInRow = [UICollectionViewLayoutAttributes]()
        var startYCoord: CGFloat = 0.0

        attributes.forEach { (a) in
            let size: GridSize.SizeType = sizes[a.indexPath] ?? .small
            a.frame.size = _gridSize.getSize(forGridSizeType: size)

            print(attributesInRow.count)
            a.frame = findEmptySpace(inRow: attributesInRow, forSize: a.frame.size, startingYCoord: startYCoord, withSpacing: _layout.inset.left)

            if a.frame.maxX == (_layout.layoutWidth - _layout.inset.left) {
                let height = attributesInRow.sorted { $0.frame.maxY > $1.frame.maxY }.first?.frame.maxY ?? 0

                if height == a.frame.maxY {
                    attributesInRow.removeAll()

                    startYCoord = height
                }
            }

            attributesInRow.append(a)
        }

        let blockPoint = attributesInRow.sorted { $0.frame.maxY > $1.frame.maxY }.first?.frame

        _furthestBlockRect = blockPoint ?? .zero

        _contentSize = .init(width: _layout.layoutWidth, height: _furthestBlockRect.maxY)

        return attributes
    }

    private func findEmptySpace(inRow attributes: [UICollectionViewLayoutAttributes], forSize size: CGSize, startingYCoord yCoord: CGFloat = 0.0, withSpacing spacing: CGFloat = 0) -> CGRect {
        var searchPoint = CGPoint.init(x: spacing, y: spacing + yCoord)
        let rectWidth = _layout.layoutWidth
        var spaceRect = CGRect.init(origin: searchPoint, size: size)

        // Y coord change
        // TODO: baaaaaaaad
        // Need to be reviewed
        // though... this function should return a rect for empty space...
        // if there is no one... so there is no one :D
        while true {

            // X coord change
            while searchPoint.x + size.width <= rectWidth {
                spaceRect.origin = searchPoint

                var isEmpty = true

                attributes.enumerated().forEach { i, a in
                    if a.frame.intersects(spaceRect) {
                        isEmpty = false
                    }
                }

                if isEmpty {
                    return spaceRect
                }

                searchPoint.x = searchPoint.x + _gridSize.smallGrid.width + spacing
            }

            searchPoint.y = searchPoint.y + _gridSize.smallGrid.height + spacing
            searchPoint.x = spacing
        }

        return spaceRect
    }
}
