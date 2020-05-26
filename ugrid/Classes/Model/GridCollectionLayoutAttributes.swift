//
//  GridCollectionLayoutAttributes.swift
//  UDifferentSizeGridView
//
//  Created by Aram Semerjyan on 5/22/20.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

class GridCollectionLayoutAttributes: UICollectionViewLayoutAttributes {

    var uuid: String!

    func setUUID(forIndexPath indexPath: IndexPath) {
        if let id = UserDefaults.standard.string(forKey: key(fromIndexPath: indexPath)) {
            uuid = id
        } else {
            uuid = UUID().uuidString

            UserDefaults.standard.set(uuid, forKey: key(fromIndexPath: indexPath))
        }

    }

    private func key(fromIndexPath indexPath: IndexPath) -> String {
        return "r:\(indexPath.row)_s:\(indexPath.section)"
    }
}
