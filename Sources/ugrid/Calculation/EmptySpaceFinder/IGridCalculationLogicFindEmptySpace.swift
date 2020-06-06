//
//  IGridCalculationLogicFindEmptySpace.swift
//  ugrid
//
//  Created by Aram Semerjyan on 5/30/20.
//  Copyright © 2020 BugCreator. All rights reserved.
//

import UIKit

protocol IGridCalculationLogicFindEmptySpace {
    func findEmtpySpace(withAttributes attributes: [UICollectionViewLayoutAttributes],
                        forGridSize size: CGSize,
                        startedFrom startCoord: CGFloat
    ) -> CGRect
}
