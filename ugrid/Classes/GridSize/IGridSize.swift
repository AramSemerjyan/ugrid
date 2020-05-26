//
//  IGridSize.swift
//  UDifferentSizeGridView
//
//  Created by Aram Semerjyan on 5/21/20.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

public enum SizeType: String {
    case small = "grid_size_small"
    case middle = "grid_size_middle"
    case big = "grid_size_big"

    mutating func toggole() {
        if self == .big {
            self = .small
        } else if self == .small {
            self = .middle
        } else {
            self = .big
        }
    }
}

// This protocol is responsible for getting item size for SizeType
// and for getting how many items for the specific SizeType
// could be placed on the layout for specific type (less/more)
protocol IGridSize {
    var smallGrid: CGSize { get }
    var middleGrid: CGSize { get }
    var bigGrid: CGSize { get }

    func setType(_ layoutType: LayoutType)
    func itemsInRow(forSize size: SizeType) -> CGFloat
    func getSize(forGridSizeType sizeType: SizeType) -> CGSize
}
