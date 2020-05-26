//
//  IConfigure.swift
//  UDifferentSizeGridView
//
//  Created by Aram Semerjyan on 5/25/20.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

protocol IConfigure {
    func setCalculationLogic(_ logic: IGridCalculation)
    func setSizeRepository(_ repo: IGridSizeRepository)
}
