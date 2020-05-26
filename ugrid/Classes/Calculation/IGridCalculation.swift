//
//  IGridCalculation.swift
//  UDifferentSizeGridView
//
//  Created by Aram Semerjyan on 5/18/20.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

public enum LayoutType {
    case less
    case more

    mutating func toggle() {
        switch self {
        case .less:
            self = .more
        case .more:
            self = .less
        }
    }
}

protocol IGridCalculation {

    var gridType: LayoutType { get set }

    var furthestBlockRect: CGRect { get }

    var contentSize: CGSize { get }

    @discardableResult
    func calculate(attributes: [UICollectionViewLayoutAttributes]?, withItemSizes sizes: [IndexPath: GridSize.SizeType]) -> [UICollectionViewLayoutAttributes]?

    func reset()
}
