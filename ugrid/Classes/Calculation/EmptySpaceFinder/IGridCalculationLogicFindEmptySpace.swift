//
//  IGridCalculationLogicFindEmptySpace.swift
//  ugrid
//
//  Created by Aram Semerjyan on 5/30/20.
//

import UIKit

protocol IGridCalculationLogicFindEmptySpace {
    func findEmptySpaceInVertical(inRow attributes: [UICollectionViewLayoutAttributes],
                                  withWidth width: CGFloat,
                                  forSize size: CGSize,
                                  startingYCoord yCoord: CGFloat,
                                  withSpacing spacing: CGFloat
    ) -> CGRect

    func findEmptySpaceInHorizontal(inRow attributes: [UICollectionViewLayoutAttributes],
                                    withHeight height: CGFloat,
                                    forSize size: CGSize,
                                    startingXCoord xCoord: CGFloat,
                                    withSpacing spacing: CGFloat
    ) -> CGRect

    func findEmptySpace(forDirrection dirrection: UICollectionViewScrollDirection,
                        withAttributes attributes: [UICollectionViewLayoutAttributes],
                        length: CGFloat,
                        size: CGSize,
                        startingCoord coord: CGFloat,
                        andSpacing spacing: CGFloat
    ) -> CGRect
}
