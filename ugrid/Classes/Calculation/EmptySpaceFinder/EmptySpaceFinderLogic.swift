//
//  EmptySpaceFinderLogic.swift
//  ugrid
//
//  Created by Aram Semerjyan on 5/30/20.
//

import UIKit

class EmptySpaceFinder {
    private(set) var layout: ILayoutScreen
    private(set) var gridSize: IGridSize

    init(gridSize: IGridSize, layout: ILayoutScreen) {
        self.gridSize = gridSize
        self.layout = layout
    }
}

class VerticalEmptySpaceFinder: EmptySpaceFinder { }

extension VerticalEmptySpaceFinder: IGridCalculationLogicFindEmptySpace {
    func findEmtpySpace(withAttributes attributes: [UICollectionViewLayoutAttributes], forGridSize size: CGSize, startCoord: CGFloat) -> CGRect {
        let spacing = layout.inset.left
        var searchPoint = CGPoint.init(x: spacing, y: startCoord + spacing)
        let rectWidth = layout.layoutWidth
        var spaceRect = CGRect.init(origin: searchPoint, size: size)

        // Y coord change
        // TODO: baaaaaaaad
        // Need to be reviewed
        // though... this function should return a rect for empty space...
        // if there is no one... so there is no one :D
        while true {

            // X coord change
            // on every iteration go to right with GridSize.SizeType.small width (currently 50)
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

                searchPoint.x = searchPoint.x + gridSize.smallGrid.width + spacing
            }

            // if there is no empty space on the line, go bottom with GridSize.SizeType.small height (currently 50)
            // to and start looking with X position equal to 0
            searchPoint.y = searchPoint.y + gridSize.smallGrid.height + spacing
            searchPoint.x = spacing
        }

        return spaceRect
    }
}

class HorizontalEmptySpaceFinder: EmptySpaceFinder { }

extension HorizontalEmptySpaceFinder: IGridCalculationLogicFindEmptySpace {
    func findEmtpySpace(withAttributes attributes: [UICollectionViewLayoutAttributes], forGridSize size: CGSize, startCoord: CGFloat) -> CGRect {
        let spacing = layout.inset.left
        var searchPoint = CGPoint.init(x: spacing + startCoord, y: spacing)
        let rectHeight = layout.layoutHeight
        var spaceRect = CGRect.init(origin: searchPoint, size: size)

        // Y coord change
        // TODO: baaaaaaaad
        // Need to be reviewed
        // though... this function should return a rect for empty space...
        // if there is no one... so there is no one :D
        while true {

            // X coord change
            // on every iteration go to right with GridSize.SizeType.small width (currently 50)
            while searchPoint.y + size.height <= rectHeight {
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

                searchPoint.y = searchPoint.y + gridSize.smallGrid.width + spacing
            }

            // if there is no empty space on the line, go bottom with GridSize.SizeType.small height (currently 50)
            // to and start looking with X position equal to 0
            searchPoint.x = searchPoint.x + gridSize.smallGrid.height + spacing
            searchPoint.y = spacing
        }

        return spaceRect
    }
}
