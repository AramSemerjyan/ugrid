//
//  IGridItemsInRow.swift
//  Pods-ugrid_Example
//
//  Created by Aram Semerjyan on 5/30/20.
//

import UIKit

public protocol IGridItemsInRow {
    func itemsInRow(forSizeType size: SizeType, andLayoutType layout: LayoutType) -> CGFloat
}
