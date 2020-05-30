//
//  EmptySpaceFinderLogic.swift
//  ugrid
//
//  Created by Aram Semerjyan on 5/30/20.
//

import UIKit

class EmptySpaceFinderLogic: IGridCalculationLogicFindEmptySpace {

    private var _gridSize: IGridSize

    init(_ gridSize: IGridSize) {
        _gridSize = gridSize
    }

    func findEmptySpaceInVertical(inRow attributes: [UICollectionViewLayoutAttributes],
                                  withWidth width: CGFloat,
                                  forSize size: CGSize,
                                  startingYCoord yCoord: CGFloat = 0.0,
                                  withSpacing spacing: CGFloat = 0.0
    ) -> CGRect {
        var searchPoint = CGPoint.init(x: spacing, y: spacing + yCoord)
        let rectWidth = width
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

                searchPoint.x = searchPoint.x + _gridSize.smallGrid.width + spacing
            }

            // if there is no empty space on the line, go bottom with GridSize.SizeType.small height (currently 50)
            // to and start looking with X position equal to 0
            searchPoint.y = searchPoint.y + _gridSize.smallGrid.height + spacing
            searchPoint.x = spacing
        }

        return spaceRect
    }

    func findEmptySpaceInHorizontal(inRow attributes: [UICollectionViewLayoutAttributes],
                                    withHeight height: CGFloat,
                                    forSize size: CGSize,
                                    startingXCoord xCoord: CGFloat = 0.0,
                                    withSpacing spacing: CGFloat = 0.0
    ) -> CGRect {
        var searchPoint = CGPoint.init(x: spacing + xCoord, y: spacing)
        let rectHeight = height
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
                
                searchPoint.y = searchPoint.y + _gridSize.smallGrid.width + spacing
            }

            // if there is no empty space on the line, go bottom with GridSize.SizeType.small height (currently 50)
            // to and start looking with X position equal to 0
            searchPoint.x = searchPoint.x + _gridSize.smallGrid.height + spacing
            searchPoint.y = spacing
        }

        return spaceRect
    }

    func findEmptySpace(forDirrection dirrection: UICollectionView.ScrollDirection, withAttributes attributes: [UICollectionViewLayoutAttributes], length: CGFloat, size: CGSize, startingCoord coord: CGFloat, andSpacing spacing: CGFloat) -> CGRect {
        if dirrection == .vertical {
            return findEmptySpaceInVertical(inRow: attributes,
                                            withWidth: length,
                                            forSize: size,
                                            startingYCoord: coord,
                                            withSpacing: spacing
            )
        } else {
            return findEmptySpaceInHorizontal(inRow: attributes,
                                              withHeight: length,
                                              forSize: size,
                                              startingXCoord: coord,
                                              withSpacing: spacing
            )
        }
    }
}
