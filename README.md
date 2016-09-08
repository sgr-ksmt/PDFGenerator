<p align="center">
  <a href="#features">Features</a> |
  <a href="#requirements">Requirements</a> |
  <a href="#installation">Installation</a> |
  <a href="#usage">Usage</a> |
  <a href="#communication">Communication</a> |
  <a href="#license">LICENSE</a>
</p>

# PDFGenerator
[![Build Status](https://travis-ci.org/sgr-ksmt/PDFGenerator.svg?branch=master)](https://travis-ci.org/sgr-ksmt/PDFGenerator)
[![GitHub release](https://img.shields.io/github/release/sgr-ksmt/PDFGenerator.svg)](https://github.com/sgr-ksmt/PDFGenerator/releases)
[![codecov](https://codecov.io/gh/sgr-ksmt/PDFGenerator/branch/master/graph/badge.svg)](https://codecov.io/gh/sgr-ksmt/PDFGenerator)
![Language](https://img.shields.io/badge/language-Swift%202.2,%20Swift%203(beta)-orange.svg)
[![Carthage](https://img.shields.io/badge/Carthage-✓-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/badge/Cocoa%20Pods-✓-4BC51D.svg?style=flat)](https://cocoapods.org)
[![Swift Package Manager](https://img.shields.io/badge/SPM-✓-brightgreen.svg)](https://github.com/apple/swift-package-manager)  
`PDFGenerator` is a simple PDF generator that generates with `UIView`, `UIImage`, ...etc .

```swift
do {
    let page: [PDFPage] = [
        .WhitePage(CGSize(width: 200, height: 100)),
        .Image(image1)
        .Image(image2)
        .ImagePath(lastPageImagePath)
        .WhitePage(CGSize(width: 200,height: 100))
    ]
    let path = NSHomeDirectory().stringByAppendingString("/sample1.pdf")
    try PDFGenerator.generate(page, outputPath: path, password: "123456")
} catch let error{
    print(error)
}
```

## Features
- Multiple pages support.
- Also generate PDF with `image path`, `image binary`, `image ref (CGImage)`
- Good memory management.
- UIScrollView support : If view is `UIScrollView`, `UITableView`, `UICollectionView`, `UIWebView`, drawn whole content.
- Outputs as binary(`NSData`) or writes to Disk(in given file path) directly.
- Corresponding to Error-Handling. Strange PDF has never been generated!!.
- DPI support. : Default dpi is 72.
- Password protection support.

## Requirements
- iOS 8.0+
- Xcode 7.0+(Swift 2.x)

## Installation

### Carthage

- Add the following to your *Cartfile*:

```bash
# Swift 2.2
github 'sgr-ksmt/PDFGenerator' ~> 1.4.3

# Swift 2.3
github 'sgr-ksmt/PDFGenerator' 'swift-2.3'

# Swift 3.0
github 'sgr-ksmt/PDFGenerator' 'swift-3.0'

```

- Then run command:

```bash
$ carthage update
```

- Add the framework as described.
<br> Details: [Carthage Readme](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application)


#### CocoaPods

**PDFGenerator** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
# Swift 2.2
pod 'PDFGenerator', '~> 1.4.3'

# Swift 2.3
pod 'PDFGenerator', :branch => 'swift-2.3'

# Swift 3.0
pod 'PDFGenerator', :branch => 'swift-3.0'

```

and run `pod install`

#### Notice (Swift3.0)
This branch is beta yet. If you found a bug, please create issue. :bow:

## Usage

### Generate from view(s) or image(s)
- UIView → PDF

```swift
func generatePDF() {
    let v1 = UIScrollView(frame: CGRectMake(0,0,100,100))
    let v2 = UIView(frame: CGRectMake(0,0,100,200))
    let v3 = UIView(frame: CGRectMake(0,0,100,200))
    v1.backgroundColor = UIColor.redColor()
    v1.contentSize = CGSize(width: 100, height: 200)
    v2.backgroundColor = UIColor.greenColor()
    v3.backgroundColor = UIColor.blueColor()

    let dst = NSHomeDirectory().stringByAppendingString("/sample1.pdf")
    // outputs as NSData
    do {
        let data = try PDFGenerator.generate([v1, v2, v3])
        data.writeToFile(dst, atomically: true)
    } catch (let error) {
        print(error)
    }

    // writes to Disk directly.
    do {
        try PDFGenerator.generate([v1, v2, v3], outputPath: dst)    
    } catch (let error) {
        print(error)
    }
}
```

`Also PDF can generate from image(s), image path(s) same as example.`

### Generate from PDFPage object

- (UIVIew or UIImage) → PDF

Use `PDFPage`.

```swift
public enum PDFPage {
    case WhitePage(CGSize) // = A white view
    case View(UIView)
    case Image(UIImage)
    case ImagePath(String)
    case Binary(NSData)
    case ImageRef(CGImage)
}
```

```swift
func generatePDF() {
    let v1 = UIView(frame: CGRectMake(0,0,100,100))
    v1.backgroundColor = UIColor.redColor()
    let v2 = UIView(frame: CGRectMake(0,0,100,200))
    v2.backgroundColor = UIColor.greenColor()

    let page1 = PDFPage.View(v1)
    let page2 = PDFPage.View(v2)
    let page3 = PDFPage.WhitePage(CGSizeMake(200, 100))
    let page4 = PDFPage.Image(UIImage(contentsOfFile: "path/to/image1.png")!)
    let page5 = PDFPage.ImagePath("path/to/image2.png")
    let pages = [page1, page2, page3, page4, page5]

    let dst = NSHomeDirectory().stringByAppendingString("/sample1.pdf")
    do {
        try PDFGenerator.generate(pages, outputPath: dst)
    } catch (let e) {
        print(e)
    }
}
```

### Generate custom dpi PDF
```swift
// generate dpi300 PDF (default: 72dpi)
func generatePDF() {
    let v1 = UIView(frame: CGRectMake(0,0,100,100))
    v1.backgroundColor = UIColor.redColor()
    let v2 = UIView(frame: CGRectMake(0,0,100,200))
    v2.backgroundColor = UIColor.greenColor()

    let page1 = PDFPage.View(v1)
    let page2 = PDFPage.View(v2)
    let pages = [page1, page2]

    let dst = NSHomeDirectory().stringByAppendingString("/sample1.pdf")
    do {
        try PDFGenerator.generate(pages, outputPath: dst, dpi: .DPI_300)
    } catch (let e) {
        print(e)
    }
}
```

### Password protection
```swift
// generate PDF with password: 123456
func generatePDF() {
    let v1 = UIView(frame: CGRectMake(0,0,100,100))
    v1.backgroundColor = UIColor.redColor()
    let v2 = UIView(frame: CGRectMake(0,0,100,200))
    v2.backgroundColor = UIColor.greenColor()

    let page1 = PDFPage.View(v1)
    let page2 = PDFPage.View(v2)
    let pages = [page1, page2]

    let dst = NSHomeDirectory().stringByAppendingString("/sample1.pdf")
    do {
        try PDFGenerator.generate(pages, outputPath: dst, password: "123456")
        // or use PDFPassword model
        try PDFGenerator.generate(pages, outputPath: dst, password: PDFPassword("123456"))
        // or use PDFPassword model and set user/owner password
        try PDFGenerator.generate(pages, outputPath: dst, password: PDFPassword(user: "123456", owner: "abcdef"))
    } catch (let e) {
        print(e)
    }
}
```


## Errors

```swift
public enum PDFGenerateError: ErrorType {
    case ZeroSizeView(UIView) // view's width or height is 0
    case ImageLoadFailed(String) // cannot load from image path
    case EmptyOutputPath // output path is empty
    case EmptyPage // Generate from empty page(s).
                   // `PDFGenerator.generate([])` isn't allowed.
}
```


## Communication
- If you found a bug, please open an issue. :bow:
- Also, if you have a feature request, please open an issue. :thumbsup:
- If you want to contribute, submit a pull request.:muscle:

## License

**PDFGenerator** is under MIT license. See the [LICENSE](LICENSE) file for more info.
