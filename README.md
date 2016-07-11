[![GitHub release](https://img.shields.io/github/release/sgr-ksmt/PDFGenerator.svg)](https://github.com/sgr-ksmt/PDFGenerator/releases)
[![Build Status](https://travis-ci.org/sgr-ksmt/PDFGenerator.svg?branch=master)](https://travis-ci.org/sgr-ksmt/PDFGenerator)  
![Language](https://img.shields.io/badge/language-Swift%202.2-orange.svg)  
[![Carthage](https://img.shields.io/badge/Carthage-✓-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/badge/Cocoa%20Pods-✓-4BC51D.svg?style=flat)](https://cocoapods.org)
[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-✓-brightgreen.svg)](https://github.com/apple/swift-package-manager)

# PDFGenerator
A simple PDF generator.  
Generate PDF from UIView/UIImage (single page or multiple page).

## Features
- Support multiple pages.
- Also generate PDF from:
    - ImagePath : that can load image with `UIImage(contentsOfFile:)`
    - Binary(`NSData`)
    - ImageRef(`CGImage`)
- Type safe.
- Good memory management.
- Generate PDF from mixed-pages.
- If view is `UIScrollView`, `UITableView`, `UICollectionView`, `UIWebView`, drawn whole content.
- Outputs as `NSData` or writes to Disk(in given file path) directly.
- Corresponding to Error-Handling. Strange PDF has never been generated!!
- DPI support (v1.2.0~): Default dpi is 72.
- Password protection (v1.3.0~)

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


## Requirements
- iOS 8.0+
- Xcode 7.0+(Swift 2.x)

## Installation (Swift 2.x)

### Carthage

- Add the following to your *Cartfile*:

```bash
github 'sgr-ksmt/PDFGenerator' ~> 1.3.0
```

- Run command
    - for Swift 2.2 : `carthage update`
    - for Swift 2.3 : `carthage update --no-use-binaries`
- Add the framework as described.
<br> Details: [Carthage Readme](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application)


### CocoaPods

**PDFGenerator** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PDFGenerator', '~> 1.3.0'
```

and run `pod install`

## Installation (Swift 3.0 beta)
### Carthage

```bash
github 'sgr-ksmt/PDFGenerator' 'swift-3.0'
```

### CocoaPods

```ruby
pod 'PDFGenerator', :branch => 'swift-3.0'
```

Notice : This branch is beta yet. If you found a bug, please create issue. :bow:

## Communication
- If you found a bug, please open an issue. :bow:
- Also, if you have a feature request, please open an issue. :thumbsup:
- If you want to contribute, submit a pull request.:muscle:

## License

**PDFGenerator** is under MIT license. See the [LICENSE](LICENSE) file for more info.
