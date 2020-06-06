//
//  GridSizeRepository.swift
//  ugrid
//
//  Created by Aram Semerjyan on 5/18/20.
//  Copyright © 2020 BugCreator. All rights reserved.
//

import UIKit

private extension IndexPath {
    var key: String {
        "r:\(self.row)_s:\(self.section)_grid_item_size"
    }
}

final class GridSizeRepository {
    
    private var _repo = UserDefaults.standard

    var defaultSize: SizeType = .small
}

extension GridSizeRepository: IGridSizeRepository {
    func size(forIndexPath indexPath: IndexPath) -> SizeType {
        if let sizeString = _repo.string(forKey: indexPath.key), let size = SizeType(rawValue: sizeString) {
            return size
        } else {

            set(size: defaultSize, forIndexPath: indexPath)

            return defaultSize
        }
    }

    func set(size: SizeType, forIndexPath indexPath: IndexPath) {
        _repo.setValue(size.rawValue, forKey: indexPath.key)
    }

    func swap(from: IndexPath, to: IndexPath) {
        let fromSize = size(forIndexPath: from)
        let toSize = size(forIndexPath: to)

        set(size: fromSize, forIndexPath: to)
        set(size: toSize, forIndexPath: from)
    }

    func clearStore() {
        for k in _repo.dictionaryRepresentation().keys where k.contains("_grid_item_size") {
            _repo.removeObject(forKey: k)
        }
    }
}
