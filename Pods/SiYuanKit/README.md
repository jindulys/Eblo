# SiYuanKit

My Swift Developing toolBox, adapted to Swift 3. The functional modules included in this toolKit are like following:

**DispatchQueue**: Provide simplified operation around `DispatchQueue`.

**Then**: Light weight class for chainable taskes.

**Utilities**: Convenience helpers.

**YSOperations**: Powerful wrapper around `Operation`.

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. To install SiYuanKit with CocoaPods:

Make sure CocoaPods is installed.

Update your Podfile to include the following:

```ruby
use_frameworks!
pod 'SiYuanKit', '~> 1.0'
```

Run `pod install`.

### Swift Package Manager

   
    import PackageDescription

    let package = Package(
      name: "EbloServer",
      targets: [],
      dependencies: [
        .Package(url: "git@github.com:jindulys/SiYuanKit.git", majorVersion: 1),
      ]
    )

