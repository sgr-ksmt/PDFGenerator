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
[![Language](https://img.shields.io/badge/language-Swift%204.2-orange.svg)]()
[![Carthage](https://img.shields.io/badge/Carthage-✓-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/badge/Cocoa%20Pods-✓-4BC51D.svg?style=flat)](https://cocoapods.org/pods/PDFGenerator)
[![CocoaPodsDL](https://img.shields.io/cocoapods/dt/PDFGenerator.svg)]()
[![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/matteocrippa/awesome-swift#pdf)
[![Reviewed by Hound](https://img.shields.io/badge/Reviewed_by-Hound-8E64B0.svg)](https://houndci.com)
<br />

`PDFGenerator` is a simple PDF generator that generates with `UIView`, `UIImage`, ...etc .

```swift
do {
    let page: [PDFPage] = [
        .whitePage(CGSize(width: 200.0, height: 100.0)),
        .image(image1)
        .image(image2)
        .imagePath(lastPageImagePath)
        .whitePage(CGSize(width: 200.0, height: 100.0))
    ]
    let path = NSTemporaryDirectory().appending("sample1.pdf")
    try PDFGenerator.generate(page, to: path, password: "123456")
} catch let error {
    print(error)
}
```

## Features
- **Swift 4 is ready** :thumbsup:
- Multiple pages support.
- Also generate PDF with `image path`, `image binary`, `image ref (CGImage)`
- Good memory management.
- UIScrollView support : If view is `UIScrollView`, `UITableView`, `UICollectionView`, `UIWebView`, drawn whole content.
- Outputs as binary(`Data`) or writes to Disk(in given file path) directly.
- Corresponding to Error-Handling. Strange PDF has never been generated!!.
- DPI support. : Default dpi is 72.
- Password protection support.

## Requirements
- iOS 8.0+
- Xcode 10+
- Swift 4.2

## Installation

### Carthage

- Add the following to your *Cartfile*:

```bash
github "sgr-ksmt/PDFGenerator" ~> 3.0
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
pod 'PDFGenerator', '~> 3.0'
```

and run `pod install`

#### Notice (Swift3.0)
This branch is beta yet. If you found a bug, please create issue. :bow:

## Usage

### Generate from view(s) or image(s)
- UIView → PDF

```swift
func generatePDF() {
    let v1 = UIScrollView(frame: CGRect(x: 0.0,y: 0, width: 100.0, height: 100.0))
    let v2 = UIView(frame: CGRect(x: 0.0,y: 0, width: 100.0, height: 200.0))
    let v3 = UIView(frame: CGRect(x: 0.0,y: 0, width: 100.0, height: 200.0))
    v1.backgroundColor = .red
    v1.contentSize = CGSize(width: 100.0, height: 200.0)
    v2.backgroundColor = .green
    v3.backgroundColor = .blue

    let dst = URL(fileURLWithPath: NSTemporaryDirectory().appending("sample1.pdf"))
    // outputs as Data
    do {
        let data = try PDFGenerator.generated(by: [v1, v2, v3])
        try data.write(to: dst, options: .atomic)
    } catch (let error) {
        print(error)
    }

    // writes to Disk directly.
    do {
        try PDFGenerator.generate([v1, v2, v3], to: dst)    
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
    case whitePage(CGSize) // = A white view
    case view(UIView)
    case image(UIImage)
    case imagePath(String)
    case binary(Data)
    case imageRef(CGImage)
}
```

```swift
func generatePDF() {
    let v1 = UIView(frame: CGRect(x: 0.0,y: 0, width: 100.0, height: 100.0))
    v1.backgroundColor = .red
    let v2 = UIView(frame: CGRect(x: 0.0,y: 0, width: 100.0, height: 200.0))
    v2.backgroundColor = .green

    let page1 = PDFPage.View(v1)
    let page2 = PDFPage.View(v2)
    let page3 = PDFPage.WhitePage(CGSizeMake(200, 100))
    let page4 = PDFPage.Image(UIImage(contentsOfFile: "path/to/image1.png")!)
    let page5 = PDFPage.ImagePath("path/to/image2.png")
    let pages = [page1, page2, page3, page4, page5]

    let dst = NSTemporaryDirectory().appending("sample1.pdf")
    do {
        try PDFGenerator.generate(pages, to: dst)
    } catch (let e) {
        print(e)
    }
}
```

### Generate custom dpi PDF
```swift
// generate dpi300 PDF (default: 72dpi)
func generatePDF() {
    let v1 = UIView(frame: CGRect(x: 0.0,y: 0, width: 100.0, height: 100.0))
    v1.backgroundColor = .red
    let v2 = UIView(frame: CGRect(x: 0.0,y: 0, width: 100.0, height: 200.0))
    v2.backgroundColor = .green

    let page1 = PDFPage.View(v1)
    let page2 = PDFPage.View(v2)
    let pages = [page1, page2]

    let dst = NSTemporaryDirectory().appending("sample1.pdf")
    do {
        try PDFGenerator.generate(pages, to: dst, dpi: .dpi_300)
    } catch (let e) {
        print(e)
    }
}
```

### Password protection
```swift
// generate PDF with password: 123456
func generatePDF() {
    let v1 = UIView(frame: CGRect(x: 0.0,y: 0, width: 100.0, height: 100.0))
    v1.backgroundColor = .red
    let v2 = UIView(frame: CGRect(x: 0.0,y: 0, width: 100.0, height: 200.0))
    v2.backgroundColor = .green

    let page1 = PDFPage.view(v1)
    let page2 = PDFPage.view(v2)
    let pages = [page1, page2]

    let dst = NSTemporaryDirectory().appending("sample1.pdf")
    do {
        try PDFGenerator.generate(pages, to: dst, password: "123456")
        // or use PDFPassword model
        try PDFGenerator.generate(pages, to: dst, password: PDFPassword("123456"))
        // or use PDFPassword model and set user/owner password
        try PDFGenerator.generate(pages, to: dst, password: PDFPassword(user: "123456", owner: "abcdef"))
    } catch let error {
        print(error)
    }
}
```

## Communication
- If you found a bug, please open an issue. :bow:
- Also, if you have a feature request, please open an issue. :thumbsup:
- If you want to contribute, submit a pull request.:muscle:

## License

**PDFGenerator** is under MIT license. See the [LICENSE](LICENSE) file for more info.
