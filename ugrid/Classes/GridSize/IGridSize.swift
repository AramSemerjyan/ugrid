//
//  IGridSize.swift
//  UDifferentSizeGridView
//
//  Created by Aram Semerjyan on 5/21/20.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

protocol IGridSize {
    var smallGrid: CGSize { get }
    var middleGrid: CGSize { get }
    var bigGrid: CGSize { get }

    func setType(_ layoutType: LayoutType)
    func getSize(forGridSizeType sizeType: GridSize.SizeType) -> CGSize
}
