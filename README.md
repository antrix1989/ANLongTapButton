ANLongTapButton
========================

[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/SKPhotoBrowser.svg?style=flat)](http://cocoadocs.org/docsets/ANLongTapButton)
[![Swift 2.0](https://img.shields.io/badge/Swift-2.0-orange.svg?style=flat)](https://developer.apple.com/swift/)

Long tap button with animated progress bar.

## Requirements
- iOS 8.0+
- Swift 2.0+
- ARC

##Installation

####CocoaPods
available on CocoaPods. Just add the following to your project Podfile:
```
pod 'ANLongTapButton'
use_frameworks!
```

## Usage

- In IB add UIButton to your view.
- in IB set class of UIButton to ANLongTapButton.
- In IB drag action to your controller with Touch Down Event (NOT Touch Up Inside!).
- In your action method add implement didTimePeriodElapseBlock.

```swift
@IBAction func onPayNowButtonTapped(longTapButton: ANLongTapButton)
{
longTapButton.didTimePeriodElapseBlock = { () -> Void in
let alert = UIAlertController(title: "Payment", message: "Payment has been made.", preferredStyle: UIAlertControllerStyle.Alert)
alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
self.presentViewController(alert, animated: true, completion: nil)
}
}

```

Checkout example project for more details.

## Author

Sergey Demchenko, antrix1989@gmail.com

## License

ANLongTapButton is available under the MIT license. See the LICENSE file for more info.
