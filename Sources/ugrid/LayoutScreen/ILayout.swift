//
//  ILayoutScreen.swift
//  UDifferentSizeGridView
//
//  Created by Aram Semerjyan on 5/18/20.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

// Just a wrapper to pass only needed info to the calculation class
// so that calculation algorith knows on wich screen it's working on

protocol ILayoutScrollingInfo {
    var scrollingDirection: UICollectionView.ScrollDirection { get set }
}

protocol ILayoutScreen {
    var inset: UIEdgeInsets { get }
    
    var layoutWidth: CGFloat { get }
    var layoutHeight: CGFloat { get }
}

protocol ILayout: ILayoutScreen, ILayoutScrollingInfo { }
