//
//  LyoutScreen.swift
//  ugrid
//
//  Created by Aram Semerjyan on 5/18/20.
//  Copyright © 2020 BugCreator. All rights reserved.
//

import UIKit

final class Layout {

    var scrollingDirection: UICollectionView.ScrollDirection

    private var _collectionView: UICollectionView!

    init(_ collectionView: UICollectionView,
         scrollingDirrection direction: UICollectionView.ScrollDirection = .vertical
    ) {
        _collectionView = collectionView
        scrollingDirection = direction
    }
}

extension Layout: ILayout {
    var inset: UIEdgeInsets {
        .init(top: 0, left: 10, bottom: 0, right: 10)
    }

    var layoutWidth: CGFloat {
        _collectionView.frame.width
    }

    var layoutHeight: CGFloat {
        _collectionView.frame.height
    }
}

