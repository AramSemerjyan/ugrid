

<p align="center">
   <img src="https://github.com/AramSemerjyan/ugrid/blob/master/Resources/logo.png" width=300 height=90 />
</p>
<p align="center">
    <a href="https://cocoapods.org/pods/ugrid">
        <img src="https://img.shields.io/cocoapods/v/ugrid.svg?style=flat"
            alt="Version">
    </a>
    <a href="https://cocoapods.org/pods/ugrid">
        <img src="https://img.shields.io/cocoapods/l/ugrid.svg?style=flat"
            alt="License">
    </a>
    <a href="https://cocoapods.org/pods/ugrid">
        <img src="https://img.shields.io/cocoapods/p/ugrid.svg?style=flat"
            alt="Platform">
    </a>
</p>

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Features
UGrid offers three different sizes for cells. Toggle between them and let UGridFlowLayout to hanlde the rest. All empty spaces will be used. UGridView is willing to be like Windows Phone home page grid view :)

<img src="https://github.com/AramSemerjyan/ugrid/blob/master/Resources/grid_view_3.gif" width="300" height="680"/>

## Implementation
Just assign instance of `UGridFlowLayout` to your collection view's `collectionViewLayout` property and you're good to go. If you want to toggle between size:

```swift
import UIKit
import ugrid

class ViewController: UIViewController {
 
   private var _layout = UGridFlowLayout()
   private var _layoutType: LayoutType = .less
 
   override func viewDidLoad() {
      super.viewDidLoad()

      collectionView.collectionViewLayout = _layout
   }
}
```

#### Toggle between Layout Types
There is two Layout Types: `less` or `more`

With `less` type in one row there will be:
* 4 small grid items
* 2 middle grid items
* 1 big grid item and there won't be any space for any other grid item

With `more` type in one row there will be:
* 6 small grid items
* 3 middle grid items
* 1 big grid item, but there will be a space for 4 small grid items or 1 middle item in the smae row

Layout Types could be toggled by calling `setType(_:)` and passing spacific `Layout Type`:

```swift
...
   override func viewDidLoad() {
      ...
      
      _layoutType = .less
      
      _layout.setType(_layoutType)
   }
...
```

#### Toggle between sizes
Just call `toggleSize(forIndexPath:)` On `UGridFlowLayout` instance. Layout will automaticall toggle between small, middle and big sizes:

```swift
...
   override func viewDidLoad() {
      ...
      
      _layoutType.toggle()
      
      _layout.setType(_layoutType)
      
      ...
   }
...
```

#### Store changes
For simplicity `UserDefaults` is used to save size for each cell index path. If you still want to handle storing by yourself You want to check [Change behaviour section](####-Change-behaviour)

#### Change behaviour
UGrid is still in development. It do it's best to bring the fastest calculation time for reordering cells, simplest implementation and usability. Though if you have a better calculation idea (which is most likely) you can create your own calculation class by simply adopting to `IGridCalculation` protocol and use `setCalculationLogic(_:)` on `UGridFlowLayout` instance to change calculation logic.
Also if you like to store sizes on your own, you can adopt to `IGridSizeRepository` protocol and set new storing mechanism by calling `setSizeRepository(_:)` on on `UGridFlowLayout` instance.

To change grid items count in the row, simply create a class that comforms to `IGridItemsInRow` and set it to `UGridFlowLayout` instance. For exmaple, to have 3 items in the row for `less` mode instead of default 4, create a new class called `CustomSizeCountInrow`:

```swift
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
```

and set it:

```swift
...
   override func viewDidLoad() {
      ...
            
      _layout.setGridItemsInRow(CustomSizeCountInrow())
      
      ...
   }
...
```

## What is planned to be done
* Section support. Currently only one section is supported
* Drag and Drop support

## Requirements
* XCode 11+
* iOS 11+

## Installation

ugrid is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ugrid'
```

## Author

Bug Creator

## License

ugrid is available under the MIT license. See the LICENSE file for more info.
