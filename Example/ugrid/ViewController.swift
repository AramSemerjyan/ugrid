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
    private var _dataSource: [Int] = Array(0...5)
    private var _layout = UGridFlowLayout()
    private var _layoutType: LayoutType = .more
    private var _dirrection: UICollectionView.ScrollDirection = .vertical

    private var _dirrectionTitle: String {
        _dirrection == .vertical ? "Horizontal" : "Vertical"
    }

    private var _layoutTypeTitle: String {
        _layoutType == .less ? LayoutType.more.rawValue : LayoutType.less.rawValue
    }

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpCollectionView()
        setUpNavigationBar()
    }

    // MARK: - private funcs
    private func setUpNavigationBar() {
        changeGridTypeItem.title = _layoutTypeTitle
        changeDirrectionItem.title = _dirrectionTitle
    }

    private func setUpCollectionView() {
        collectionView.collectionViewLayout = _layout

        collectionView.register(UINib(nibName: "UGridCell", bundle: nil), forCellWithReuseIdentifier: "grid_cell")

        _layout.setGridItemsInRow(CustomSizeCountInrow())
        _layout.scrollDirection = _dirrection

        collectionView.dataSource = self
        collectionView.delegate = self

        _layout.setType(_layoutType)
    }

    @IBAction func changeDirrection(_ sender: UIBarButtonItem) {
        _dirrection.toggle()

        sender.title = _dirrectionTitle

        _layout.scrollDirection = _dirrection
    }

    @IBAction func changeGridType(_ sender: UIBarButtonItem) {
        _layoutType.toggle()
        _layout.setType(_layoutType)

        sender.title = _layoutTypeTitle
    }

    @IBAction func addNewItem(_ sender: Any) {
        if let last = _dataSource.last {
            _dataSource.append(last + 1)
            collectionView.reloadData()
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        _dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "grid_cell", for: indexPath) as? UGridCell {
            
            cell.backgroundColor = .uBlue
            cell.numberLabel.text = _dataSource[indexPath.row].stringValue

            return cell
        } else {
            return UICollectionViewCell()
        }
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
                return 8
            case .middle:
                return 4
            case .big:
                return 1
            }
        }
    }
}

private extension UICollectionView.ScrollDirection {
    mutating func toggle() {
        if self == .horizontal {
            self = .vertical
        } else {
            self = .horizontal
        }
    }
}
