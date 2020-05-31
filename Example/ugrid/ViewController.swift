//
//  ViewController.swift
//  ugrid
//
//  Created by Aram Semerjyan on 05/26/2020.
//  Copyright (c) 2020 Aram Semerjyan. All rights reserved.
//

import UIKit
import ugrid

class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var changeGridTypeItem: UIBarButtonItem!
    @IBOutlet weak var changeDirrectionItem: UIBarButtonItem!

    // MARK: - private vars
    private var _dataSource: [Int] = Array(0...1000)
    private var _layout = UGridFlowLayout()
    private var _layoutType: LayoutType = .less
    private var _dirrection: UICollectionView.ScrollDirection = .vertical

    private var _dirrectionTitle: String {
        _dirrection == .vertical ? "Horizontal" : "Vertical"
    }

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpCollectionView()
        setUpNavigationBar()
    }

    // MARK: - private funcs
    private func setUpNavigationBar() {
        changeGridTypeItem.title = LayoutType.more.rawValue
        changeDirrectionItem.title = _dirrectionTitle
    }

    private func setUpCollectionView() {
        collectionView.collectionViewLayout = _layout

        _layout.setGridItemsInRow(CustomSizeCountInrow())
        _layout.scrollDirection = _dirrection

        collectionView.dataSource = self
        collectionView.delegate = self

        _layout.setType(_layoutType)
    }

    @IBAction func changeDirrection(_ sender: UIBarButtonItem) {
        if _dirrection == .vertical {
            _dirrection = .horizontal
        } else {
            _dirrection = .vertical
        }

        sender.title = _dirrectionTitle

        _layout.scrollDirection = _dirrection
    }

    @IBAction func changeGridType(_ sender: UIBarButtonItem) {
        sender.title = _layoutType.rawValue

        _layoutType.toggle()

        _layout.setType(_layoutType)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        _dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath)

        cell.backgroundColor = .init(red: (135 / 255), green: (206 / 255), blue: (250 / 255), alpha: 1)

        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _layout.toggleSize(forIndexPath: indexPath)
    }
}

// If you want to use your own items count, you can create class that conform to IGridItemsInRow
// and declare your own items count for the row
class CustomSizeCountInrow: IGridItemsInRow {
    func itemsInRow(forSizeType size: SizeType, andLayoutType layout: LayoutType) -> CGFloat {

        switch layout {
        case .less:
            switch size {
            case .small:
                return 3
            case .middle:
                return 1.5
            case .big:
                return 1
            }
        case .more:
            switch size {
            case .small:
                return 6
            case .middle:
                return 3
            case .big:
                return 1
            }
        }
    }
}
