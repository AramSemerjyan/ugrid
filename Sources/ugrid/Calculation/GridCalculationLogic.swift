//
//  GridCalculationLogic.swift
//  ugrid
//
//  Created by Aram Semerjyan on 5/18/20.
//  Copyright © 2020 BugCreator. All rights reserved.
//

import UIKit

final class GridCalculationLogic: IGridCalculation {

    // MARK: - private vars
    private var _repo: IGridSizeRepository!
    private var _layout: ILayout!
    private var _gridSize: IGridSize!

    private lazy var _emptySpaceFinder: [Int: IGridCalculationLogicFindEmptySpace] = {
        [
            UICollectionView.ScrollDirection.vertical.rawValue: VerticalEmptySpaceFinder(gridSize: self._gridSize, layout: self._layout),
            UICollectionView.ScrollDirection.horizontal.rawValue: HorizontalEmptySpaceFinder(gridSize: self._gridSize, layout: self._layout)
        ]
    }()

    // Search for the rows that has same maxY for Vertical case or same maxX for Horizontal case
    // if there is rows, they should be removed from the array of attributes to simplify calculation and increase speed
    private lazy var _findCompleteRows: [Int: IGridCompleteRowFinder] = {
        [
            UICollectionView.ScrollDirection.vertical.rawValue: ClearVerticalCompleteRow(gridSize: self._gridSize),
            UICollectionView.ScrollDirection.horizontal.rawValue: ClearHorizontalCompleteRow(gridSize: self._gridSize)
        ]
    }()

    private var _furthestBlockRect: CGRect = .zero
    private var _contentSize: CGSize = .zero

    // MARK: - life cycle
    required init(_ layout: ILayout, gridSize: IGridSize) {
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
                   withItemSizes sizes: [IndexPath: SizeType]
    ) -> [UICollectionViewLayoutAttributes]? {

        guard let attributes = attributes else { return nil }

        guard !attributes.isEmpty else { return attributes }

        var attributesInRow = [UICollectionViewLayoutAttributes]()

        // TODO: I don't like the idea of having start coordinate here
        // Y coord from where algorithm should start to look for empy space
        var startCoord: CGFloat = 0.0

        attributes.forEach { (a) in
            let size: SizeType = sizes[a.indexPath] ?? .small
            a.frame.size = _gridSize.getSize(forGridSizeType: size)

            // TODO: need to be reviewed
            let spaceRect = _emptySpaceFinder[_layout.scrollingDirection.rawValue]?.findEmtpySpace(
                withAttributes: attributesInRow,
                forGridSize: a.frame.size,
                startedFrom: startCoord
                ) ?? .zero

            a.frame = spaceRect

            attributesInRow.append(a)

            // This will decrease complexity
            // If there is fully complete line, like:
            // if grid type is 'less', and there is [small, small, small, small] in one line
            // this will remove all four attributes, because there is no point for having them
            // while looking for empty space
            _findCompleteRows[_layout.scrollingDirection.rawValue]?.findCompleteRows(
                inAttributes: attributesInRow,
                completion: { (v) in
                    attributesInRow.removeAll()

                    startCoord = v
            })
        }

        // TODO: need to be revied
        if _layout.scrollingDirection == .vertical {
            let blockPoint = attributesInRow.sorted { $0.frame.maxY > $1.frame.maxY }.first?.frame

            _furthestBlockRect = blockPoint ?? .zero

            _contentSize = .init(width: _layout.layoutWidth, height: _furthestBlockRect.maxY)
        } else {
            let blockPoint = attributesInRow.sorted { $0.frame.maxX > $1.frame.maxX }.first?.frame

            _furthestBlockRect = blockPoint ?? .zero

            _contentSize = .init(width: _furthestBlockRect.maxX, height: _layout.layoutHeight)
        }

        return attributes
    }
}
