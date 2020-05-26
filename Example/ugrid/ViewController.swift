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

    // MARK: - private vars
    private var _dataSource: [Int] = Array(0...100)
    private var _layout = UGridFlowLayout()
    private var _layoutType: LayoutType = .less

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpCollectionView()
        setUpNavigationBar()
    }

    // MARK: - private funcs
    private func setUpNavigationBar() {
        changeGridTypeItem.title = LayoutType.more.rawValue
    }

    private func setUpCollectionView() {
        collectionView.collectionViewLayout = _layout

        collectionView.dataSource = self
        collectionView.delegate = self

        _layout.setType(_layoutType)
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
