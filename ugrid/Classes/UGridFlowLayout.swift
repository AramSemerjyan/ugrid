//
//  UGridFlowLayout.swift
//  UDifferentSizeGridView
//
//  Created by Aram Semerjyan on 5/18/20.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

public class UGridFlowLayout: UICollectionViewFlowLayout {

    enum LoggingType {
        case enable
        case disable
    }

    public override init() {
        super.init()

        addObservers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - public funcs
    public func setType(_ type: LayoutType) {
        self._calculation.gridType = type

        invalidateLayout()
    }

    public func toggleSize(forIndexPath indexPath: IndexPath) {
        var oldSize = _repo.size(forIndexPath: indexPath)
        oldSize.toggole()

        _repo.set(size: oldSize, forIndexPath: indexPath)

        UIView.performWithoutAnimation { [_collectView] in
            _collectView.performBatchUpdates({
                _collectView.reloadItems(at: [indexPath])
            }, completion: nil)
        }
    }

    func logging(_ type: LoggingType) {
        _loggign = type
    }

    // TODO: currectly handle drag and drop
    func willBegginDragging() {

    }

    func drag(fromIndexPath from: IndexPath, toIndexPath to: IndexPath) {

        if to == _draggingLastIndexPath {
            return
        }

        let fromIndexPath = _draggingLastIndexPath ?? from

        let fromSize = _sizes[fromIndexPath]
        _sizes[fromIndexPath] = _sizes[to]
        _sizes[to] = fromSize

        _draggingLastIndexPath = to
    }

    func drop(fromIndexPath from: IndexPath, toIndexPath to: IndexPath) {
        _repo.swap(from: from, to: to)
    }

    func dragDidEnded() {
        _draggingLastIndexPath = nil

        _cachedAttributes.forEach { (k, v) in
            _sizes[k] = _repo.size(forIndexPath: v.indexPath)
        }
    }

    // MARK: - private vars
    private lazy var _gridInRow: IGridSize = {
        return GridSize(gridType: .more,
                        layout: _layout,
                        gridInRow: GridItemsInRow()
        )

    }()

    private lazy var _calculation: IGridCalculation = {
        return GridCalculationLogic(_layout,
                                    gridSize: _gridInRow)
    }()

    private lazy var _layout: ILayout = {
        return Layout(_collectView, scrollingDirrection: scrollDirection)
    }()

    private lazy var _repo: IGridSizeRepository = {
        return GridSizeRepository()
    }()

    private var _loggign = LoggingType.disable

    private var _cachedAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]

    private var _sizes = [IndexPath: SizeType]()
    private var _draggingLastIndexPath: IndexPath?

    var isDragging = false {
        willSet {
            if newValue {
                willBegginDragging()
            } else {
                dragDidEnded()
            }
        }
    }

    private var _collectView: UICollectionView {
        if let cv = self.collectionView {
            return cv
        } else {
            assertionFailure("Collection view can't be nil")
            return UICollectionView()
        }
    }

    // MARK: - life cycle
    public override func invalidateLayout() {

        if _loggign == .enable {
            print("UGRID:: Invalidated")
        }

        super.invalidateLayout()

        _cachedAttributes.removeAll()
    }

    public override func prepare() {
        var array = [UICollectionViewLayoutAttributes]()
        var size = [IndexPath: SizeType]()

        for i in 0..<_collectView.numberOfItems(inSection: 0) {

            let indexPath = IndexPath(row: i, section: 0)

            size[indexPath] = _repo.size(forIndexPath: indexPath)

            let attribute = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)

            _cachedAttributes[indexPath] = attribute

            array.append(attribute)
        }

        if !isDragging {
            _sizes = size
        }

        _calculation.calculate(attributes: array, withItemSizes: _sizes)

        if _loggign == .enable {
            print("UGRID:: Perpare: \(_cachedAttributes)")
        }
    }

    public override var collectionViewContentSize: CGSize {

        var rect = _collectView.frame.size

        if scrollDirection == .vertical {
            rect.height = _calculation.furthestBlockRect.maxY
        } else {
            rect.width = _calculation.furthestBlockRect.maxX
        }

        if _loggign == .enable {
            print("UGRID:: ContentSize: \(rect)")
        }

        return rect
    }

    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        var attributeList = [UICollectionViewLayoutAttributes]()

        for (_, attributes) in _cachedAttributes {
          if attributes.frame.intersects(rect) {
            attributeList.append(attributes)
          }
        }

        if _loggign == .enable {
            print("UGRID:: rect: \(rect)")
            print("UGRID:: Attributes for rect: \(attributeList)")
        }

        return attributeList
    }

    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return _cachedAttributes[indexPath]
    }

    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "scrollDirection", let newValue = change?[NSKeyValueChangeKey.newKey] as? Int, let newDirection = UICollectionView.ScrollDirection.init(rawValue: newValue) {
            _layout.scrollingDirection = newDirection

            invalidateLayout()
        }
    }

    // MARK: - private funcs
    private func addObservers() {
        addScrollingDirrectionObserver()
    }

    private func addScrollingDirrectionObserver() {
        self.addObserver(self, forKeyPath: "scrollDirection", options: .new, context: nil)
    }
}

extension UGridFlowLayout: IConfigure {
    public func setCalculationLogic(_ logic: IGridCalculation) {
        _calculation = logic
    }

    public func setSizeRepository(_ repo: IGridSizeRepository) {
        _repo = repo
    }

    public func setGridItemsInRow(_ itemsInRow: IGridItemsInRow) {
        _gridInRow.setGirdItemsInRow(itemsInRow)
    }
}
