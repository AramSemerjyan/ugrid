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

    private lazy var _emptySpaceFinder: IGridCalculationLogicFindEmptySpace = {
        EmptySpaceFinderLogic(_gridSize)
    }()

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

    func reset() {
        _furthestBlockRect = .zero
        _contentSize = .zero
    }

    @discardableResult
    func calculate(attributes: [UICollectionViewLayoutAttributes]?,
                   withItemSizes sizes: [IndexPath: SizeType],
                   forDirrection dirrection: UICollectionViewScrollDirection
    ) -> [UICollectionViewLayoutAttributes]? {

        guard let attributes = attributes else { return nil }

        guard !attributes.isEmpty else { return attributes }

        var attributesInRow = [UICollectionViewLayoutAttributes]()

        // Y coord from where algorithm should start to look for empy space
        var startCoord: CGFloat = 0.0

        attributes.forEach { (a) in
            let size: SizeType = sizes[a.indexPath] ?? .small
            a.frame.size = _gridSize.getSize(forGridSizeType: size)

            let spaceRect = dirrection == .vertical ?
                _emptySpaceFinder.findEmptySpaceInVertical(inRow: attributesInRow,
                                                           withWidth: _layout.layoutWidth,
                                                           forSize: a.frame.size,
                                                           startingYCoord: startCoord,
                                                           withSpacing: _layout.inset.left
                ) :
                _emptySpaceFinder.findEmptySpaceInHorizontal(inRow: attributesInRow,
                                                             withHeight: _layout.layoutHeight,
                                                             forSize: a.frame.size,
                                                             startingXCoord: startCoord,
                                                             withSpacing: _layout.inset.left
            )

            a.frame = spaceRect

            // This will decrease complexity
            // If there is fully complete line, like:
            // if grid type is 'less', and there is [small, small, small, small] in one line
            // this will remove all four attributes, because there is no point for having them
            // while looking for empty space
            if dirrection == .vertical {
                if a.frame.maxX == (_layout.layoutWidth - _layout.inset.left) {
                    let height = attributesInRow.sorted { $0.frame.maxY > $1.frame.maxY }.first?.frame.maxY ?? 0

                    // Check that heigh for all items in the line is same
                    // if it's not, that means that there can be an empy space to place new item
                    if height == a.frame.maxY {
                        attributesInRow.removeAll()

                        startCoord = height
                    }
                }
            } else {
                if a.frame.maxY == (_layout.layoutHeight - _layout.inset.left) {
                    let width = attributesInRow.sorted { $0.frame.maxX > $1.frame.maxX }.first?.frame.maxX ?? 0

                    // Check that heigh for all items in the line is same
                    // if it's not, that means that there can be an empy space to place new item
                    if width == a.frame.maxX {
                        attributesInRow.removeAll()

                        startCoord = width
                    }
                }
            }

            attributesInRow.append(a)
        }

        let blockPoint = attributesInRow.sorted { $0.frame.maxX > $1.frame.maxX }.first?.frame

        _furthestBlockRect = blockPoint ?? .zero

        _contentSize = .init(width: _furthestBlockRect.maxX, height: _layout.layoutHeight)

        return attributes
    }
}
