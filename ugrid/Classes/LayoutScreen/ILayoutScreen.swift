//
//  ILayoutScreen.swift
//  UDifferentSizeGridView
//
//  Created by Aram Semerjyan on 5/18/20.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

protocol ILayoutScreen {
    var inset: UIEdgeInsets { get }
    var layoutWidth: CGFloat { get }
}
