# WebHeadersController [![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/Carthage/Carthage/master/LICENSE.md) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

A WKWebView based view controller that supports adding HTTP headers and toolbar/accessory view hiding.

# Features
- Add custom ```[String: String]``` headers to the WKWebView URL request
- Toggle WKWebView toolbar & keyboard accessory view

# Installation

### Carthage
If you're using [Carthage](https://github.com/Carthage/Carthage) you can add a dependency on WebHeadersController by adding it to your `Cartfile`:

```
github "kylebegeman/WebHeadersController" ~> 0.1
```

# Usage

### Push

Push onto an existing navigation controller:

``` swift
let vc = WHViewController(urlString: url, headers: headers, showToolbar: showToolbar, showKeyboardAccessory: showKeyboardAccessory)
self.navigationController?.pushViewController(vc, animated: true)
```

### Modal

Present modally with a built in navigation controller. Customize the dismiss button title; otherwise defaults to "Close"

``` swift
let vc = WHModalViewController(urlString: url, headers: headers, showToolbar: showToolbar, showKeyboardAccessory: showKeyboardAccessory, dismissTitle: dismissTitle)
self.present(vc, animated: true, completion: nil)
```

# To Do
- Include error handling
- Configure with custom toolbar buttons
- Allow for UI configuration (ex: tint)

# Contributing

Contributions are very welcome 👍
