//
//  IGridSizeRepository.swift
//  UDifferentSizeGridView
//
//  Created by Aram Semerjyan on 5/18/20.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

protocol IGridSizeRepository {

    func size(forIndexPath indexPath: IndexPath) -> GridSize.SizeType
    func set(size: GridSize.SizeType, forIndexPath indexPath: IndexPath)
    func swap(from: IndexPath, to: IndexPath)
}
