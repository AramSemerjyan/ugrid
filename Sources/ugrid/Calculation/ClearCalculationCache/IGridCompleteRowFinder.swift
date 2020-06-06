//
//  IGridCalculationClearCache.swift
//  ugrid
//
//  Created by Aram Semerjyan on 5/30/20.
//

import UIKit

protocol IGridCompleteRowFinder {

    func findCompleteRows(inAttributes attributes: [UICollectionViewLayoutAttributes],
                          completion: @escaping (CGFloat) -> Void
    )
}
