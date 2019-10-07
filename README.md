ANLongTapButton
========================

[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/ANLongTapButton.svg?style=flat)](http://cocoadocs.org/docsets/ANLongTapButton)
[![Swift 4.2](https://img.shields.io/badge/Swift-4.2-orange.svg?style=flat)](https://developer.apple.com/swift/)

Long tap button with animated progress bar.

<img src="Screenshots/example01.gif" width="170">
<img src="Screenshots/example02.gif" width="170">

## Requirements
- iOS 8.0+
- Swift 4.2
- ARC

##Installation

####CocoaPods
Available on CocoaPods. Just add the following to your project Podfile:
```
pod 'ANLongTapButton'
use_frameworks!
```

## Usage

- In IB add UIButton to your view.
- In IB set class of UIButton to ANLongTapButton.
- In IB set module name of UIButton to ANLongTapButton.
- In IB drag action to your controller with Touch Down Event (NOT Touch Up Inside!).
- In your action method add implement didTimePeriodElapseBlock.

```swift
@IBAction func onPayNowButtonTapped(longTapButton: ANLongTapButton)
{
  longTapButton.didTimePeriodElapseBlock = { () -> Void in
    let alert = UIAlertController(title: "Payment", message: "Payment has been made.", preferredStyle:   UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
  }
}

```

See example project for more details.

## Author

Sergey Demchenko, antrix1989@gmail.com

## License

ANLongTapButton is available under the MIT license. See the LICENSE file for more info.
