//
//  GridSizeRepository.swift
//  UDifferentSizeGridView
//
//  Created by Aram Semerjyan on 5/18/20.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

final class GridSizeRepository {
    private var _repo = UserDefaults.standard

    var defaultSize: SizeType = .small

    // MARK: - private var
    private func key(fromIndexPath indexPath: IndexPath) -> String {
        return "r:\(indexPath.row)_s:\(indexPath.section)"
    }
}

extension GridSizeRepository: IGridSizeRepository {
    func size(forIndexPath indexPath: IndexPath) -> SizeType {
        if let sizeString = _repo.string(forKey: key(fromIndexPath: indexPath)), let size = SizeType(rawValue: sizeString) {
            return size
        } else {

            set(size: defaultSize, forIndexPath: indexPath)

            return defaultSize
        }
    }

    func set(size: SizeType, forIndexPath indexPath: IndexPath) {
        _repo.setValue(size.rawValue, forKey: key(fromIndexPath: indexPath))
    }

    func swap(from: IndexPath, to: IndexPath) {
        let fromSize = size(forIndexPath: from)
        let toSize = size(forIndexPath: to)

        set(size: fromSize, forIndexPath: to)
        set(size: toSize, forIndexPath: from)
    }
}
