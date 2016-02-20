![Language](https://img.shields.io/badge/language-Swift%202%2B-orange.svg)
[![Xcode](https://img.shields.io/badge/Xcode-7.0%2B-brightgreen.svg?style=flat)]()
[![iOS](https://img.shields.io/badge/iOS-8.0%2B-brightgreen.svg?style=flat)]()
[![Build Status](https://travis-ci.org/sgr-ksmt/PDFGenerator.svg?branch=master)](https://travis-ci.org/sgr-ksmt/PDFGenerator)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Pod Version](https://img.shields.io/cocoapods/v/PDFGenerator.svg?style=flat)](http://cocoapods.org/pods/PDFGenerator)

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
- If view is `UIScrollView` , drawn whole content.
- Outputs as `NSData` or writes to Disk(in given file path) directly.
- Corresponding to Error-Handling. Strange PDF has never been generated!!

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
- Xcode 7.0+(Swift 2+)

## Installation

### Carthage

- Add the following to your *Cartfile*:

```bash
github 'sgr-ksmt/PDFGenerator', '~> 1.0.0'
```

- Run `carthage update`
- Add the framework as described.
<br> Details: [Carthage Readme](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application)


### CocoaPods

**PDFGenerator** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PDFGenerator', '~> 1.0.0'
```

and run `pod install`


## Communication
- If you found a bug, open an issue.
- If you have a feature request, open an issue.
- If you want to contribute, submit a pull request.:muscle:

## License

**PDFGenerator** is under MIT license. See the [LICENSE](LICENSE) file for more info.