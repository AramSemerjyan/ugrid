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
    private var _direction: UICollectionViewScrollDirection!

    init(_ collectionView: UICollectionView,
         scrollingDirrection direction: UICollectionViewScrollDirection = .vertical
    ) {
        _collectionView = collectionView
        _direction = direction
    }

    var layoutWidth: CGFloat {
        _collectionView.frame.width
    }

    var layoutHeight: CGFloat {
        _collectionView.frame.height
    }

    var inset: UIEdgeInsets {
        .init(top: 0, left: 10, bottom: 0, right: 10)
    }

    var scrollingDirection: UICollectionViewScrollDirection {
        set { _direction = newValue }

        get { _direction }
    }
}
