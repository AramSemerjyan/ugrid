//
//  IGridCalculation.swift
//  ugrid
//
//  Created by Aram Semerjyan on 5/18/20.
//  Copyright © 2020 BugCreator. All rights reserved.
//

import UIKit

// Detects how many items should be placed on the layout
// 'less':
//      small - 4 in the row
//      middle - 2 in the row
//      bid - 1 in the row, no any item can be placed in the row
// 'more':
//      small - 6 in the row
//      middle - 3 in the row
//      bid - 1 in the row, but still can be places 4 small or 1 middle size item in the same row
public enum LayoutType: String {
    case less = "Less items"
    case more = "More items"

    public mutating func toggle() {
        switch self {
        case .less:
            self = .more
        case .more:
            self = .less
        }
    }
}

// this protocol is responsible for calculating and placing grid items on the screen
public protocol IGridCalculation {

    var gridType: LayoutType { get set }

    var furthestBlockRect: CGRect { get }

    var contentSize: CGSize { get }

    @discardableResult
    func calculate(attributes: [UICollectionViewLayoutAttributes]?,
                   withItemSizes sizes: [IndexPath: SizeType]
    ) -> [UICollectionViewLayoutAttributes]?

    func reset()
}
