[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/PDFGenerator.svg?style=flat)](http://cocoapods.org/pods/PDFGenerator)
[![License](https://img.shields.io/cocoapods/l/PDFGenerator.svg?style=flat)](http://cocoapods.org/pods/PDFGenerator)
[![Platform](https://img.shields.io/cocoapods/p/PDFGenerator.svg?style=flat)](http://cocoapods.org/pods/PDFGenerator)

# PDFGenerator
A simple PDF generator.

## Features

- Generate PDF from UIView/UIImage
- Support multiple page PDF
- Also generate PDF from imagePath that can load image with `UIImage(contentsOfFile:)`
- If view is `UIScrollView` , drawn whole content.
- Outputs as `NSData` or writes to Disk(in given file path) directly.

## Usage

- UIView → PDF

```swift
func saveToPDF() {
    let v1 = UIScrollView(frame: CGRectMake(0,0,100,100))
    let v2 = UIView(frame: CGRectMake(0,0,100,200))
    let v3 = UIView(frame: CGRectMake(0,0,100,200))
    v1.backgroundColor = UIColor.redColor()
    v1.contentSize = CGSize(width: 100, height: 200)
    v2.backgroundColor = UIColor.greenColor()
    v3.backgroundColor = UIColor.blueColor()

    let dst = NSHomeDirectory().stringByAppendingString("/sample\(1).pdf")
    // outputs as NSData
    let data = PDFGenerator.generate([v1, v2, v3])
    data.writeToFile(dst, atomically: true)

    // writes to Disk directly.
    // PDFGenerator.generate([v1, v2, v3], outputPath: dst)
}
```

- UIImage → PDF

```swift
func saveToPDF() {
    let dst = NSHomeDirectory().stringByAppendingString("/sample\(1).pdf")
    // outputs as NSData
    let data = PDFGenerator.generate([img1, img2, img3])
    data.writeToFile(dst, atomically: true)
    // writes to Disk directly.
    // PDFGenerator.generate([img1, img2, img3], outputPath: dst)
}
```

```swift
func saveToPDF() {
    let dst = NSHomeDirectory().stringByAppendingString("/sample\(1).pdf")
    // outputs as NSData
    let data = PDFGenerator.generate([imgPath1, imgPath2, imgPath3])
    data.writeToFile(dst, atomically: true)
    // writes to Disk directly.
    // PDFGenerator.generate([imgPath1, imgPath2, imgPath3], outputPath: dst)
}
```

## Requirements
- iOS 8.0+
- Xcode 7.0+(Swift 2+)

## Installation

### Carthage

- Add the following to your *Cartfile*:

```bash
github "sgr-ksmt/PDFGenerator"
```

- Run `carthage update`
- Add the framework as described.
<br> Details: [Carthage Readme](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application)


### CocoaPods

**PDFGenerator** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PDFGenerator'
```

and run `pod install`


## Communication
- If you found a bug, open an issue.
- If you have a feature request, open an issue.
- If you want to contribute, submit a pull request.:muscle:

## License

**PDFGenerator** is under MIT license. See the [LICENSE](LICENSE) file for more info.