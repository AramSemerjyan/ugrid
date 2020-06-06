//
//  IConfigure.swift
//  ugrid
//
//  Created by Aram Semerjyan on 5/25/20.
//  Copyright © 2020 BugCreator. All rights reserved.
//

import UIKit

public protocol ICustomizable {
    func setCalculationLogic(_ logic: IGridCalculation)
    func setSizeRepository(_ repo: IGridSizeRepository)
    func setGridItemsInRow(_ itemsInRow: IGridItemsInRow)
    func setDefaultGridSize(_ size: SizeType)
}
