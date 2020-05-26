//
//  LyoutScreen.swift
//  UDifferentSizeGridView
//
//  Created by Aram Semerjyan on 5/18/20.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

class LyoutScreen: ILayoutScreen {

    private var _collectionView: UICollectionView!

    init(_ collectionView: UICollectionView) {
        _collectionView = collectionView
    }

    var layoutWidth: CGFloat {
        return _collectionView.frame.width
    }

    var inset: UIEdgeInsets {
        return .init(top: 0, left: 10, bottom: 0, right: 10)
    }
}
