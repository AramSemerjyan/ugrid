//
//  UGridFlowLayout.swift
//  ugrid
//
//  Created by Aram Semerjyan on 5/18/20.
//  Copyright © 2020 BugCreator. All rights reserved.
//

import UIKit

public class UGridFlowLayout: UICollectionViewFlowLayout {

    private enum KeyPaths: String {
        case dirrectionChagne = "scrollDirection"
    }

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

    /// Toggle between `more` and `less` cases.
    /// Based on `IGridItemsInRow` in one row will be shown items with count corresponding for the
    /// `LayoutType` case. On `LayoutType` call `.toggle()` to switch between enum cases
    ///
    /// - Parameters:
    ///   - type: enum case from `LayoutType`
    public func setType(_ type: LayoutType) {
        self._calculation.gridType = type

        invalidateLayout()
    }

    /// Toggle Grid item sizes. Get old size, switch to next corresponding size, save using
    /// instance that conforms to `IGridSizeRepository` and perform UI changes
    ///
    /// - Parameters:
    ///   - indexPath: `IndexPath` of the item to be changed
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

    /// Remove all saved sizes for IndexPaths
    public func resetItemsSizes() {
        _repo.clearStore()
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
        if keyPath == KeyPaths.dirrectionChagne.rawValue,
            let newValue = change?[NSKeyValueChangeKey.newKey] as? Int,
            let newDirection = UICollectionView.ScrollDirection.init(rawValue: newValue)
        {
            _layout.scrollingDirection = newDirection

            invalidateLayout()
        }
    }

    // MARK: - private funcs
    private func addObservers() {
        addScrollingDirrectionObserver()
    }

    private func addScrollingDirrectionObserver() {
        self.addObserver(self, forKeyPath: KeyPaths.dirrectionChagne.rawValue, options: .new, context: nil)
    }
}

extension UGridFlowLayout: ICustomizable {

    /// Logic that is used to position items on layout.
    /// Will be used every time on `UICollectionViewFlowLayout` `prepare` call
    ///
    /// - Parameters:
    ///   - logic: class or struct that conforms to `IGridCalculation`
    public func setCalculationLogic(_ logic: IGridCalculation) {
        _calculation = logic
    }

    /// Persistence store to cache sizes for each `IndexPath`
    ///
    /// - Parameters:
    ///   - repo: class or struct that conforms to `IGridSizeRepository`
    public func setSizeRepository(_ repo: IGridSizeRepository) {
        _repo = repo
    }

    /// Represents how many items should be in one row.
    /// Differenct items count is used for `LayoutType` `Horizontal`
    /// and `Vertical`. If `scrollingDirrection` is `Horizontal` items positioned at the same `X`
    /// coordinate will be considered as a row, and if it is `Vertical` items positioned at the same `Y`
    /// coordinated wil lbe considered as a row
    ///
    /// - Parameters:
    ///   - itemsInRow: class or struct that conforms to `IGridItemsInRow`
    public func setGridItemsInRow(_ itemsInRow: IGridItemsInRow) {
        _gridInRow.setGirdItemsInRow(itemsInRow)
    }

    /// `SizeType` value to set if there isn't any size info about `IndexPath` yet in the store
    /// Currently defualt value is `small`
    ///
    /// - Parameters:
    ///   - size: Case of the `SizeType` enum
    public func setDefaultGridSize(_ size: SizeType) {
        _repo.defaultSize = size
    }
}
