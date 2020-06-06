//
//  IGridCalculationLogicFindEmptySpace.swift
//  ugrid
//
//  Created by Aram Semerjyan on 5/30/20.
//

import UIKit

protocol IGridCalculationLogicFindEmptySpace {
    func findEmtpySpace(withAttributes attributes: [UICollectionViewLayoutAttributes],
                        forGridSize size: CGSize,
                        startedFrom startCoord: CGFloat
    ) -> CGRect
}
