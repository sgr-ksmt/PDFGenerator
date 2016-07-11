//
//  PDFGeneratorTests.swift
//  PDFGeneratorTests
//
//  Created by Suguru Kishimoto on 2016/02/04.
//
//

import XCTest
import PDFGenerator

class Mock {
    struct ImageName {
        static let testImage1 = "test_image1"
    }
    
    class func view(size: CGSize) -> UIView {
        return UIView(frame: CGRect(origin: CGPoint.zero, size: size))
    }
    
    class func imagePath(name: String) -> String{
        return NSBundle(forClass: self).pathForResource(name, ofType: "png")!
    }
    
    class func image(name: String) -> UIImage {
        return UIImage(contentsOfFile: imagePath(name))!
    }
    
}

class PDFGeneratorTests: XCTestCase {
    
    func isExistPDF(path: String) -> Bool {
        return NSFileManager.defaultManager().fileExistsAtPath(path)
    }
    
    
    func PDFDirectoryPath() -> String {
        return NSHomeDirectory().stringByAppendingString("/test/")
    }
    
    func PDFfilePath(fileName: String) -> String {
        return PDFDirectoryPath().stringByAppendingString("/\(fileName)")
    }
    
    override func setUp() {
        super.setUp()
        try! NSFileManager.defaultManager().createDirectoryAtPath(
            PDFDirectoryPath(),
            withIntermediateDirectories: true,
            attributes: nil
        )
    }
    
    override func tearDown() {
        _ = try? NSFileManager.defaultManager().removeItemAtPath(PDFDirectoryPath())
        super.tearDown()
    }
    
    // MARK: UIView -> PDF
    func testViewToPDF() {
        let view = Mock.view(CGSize(width: 100, height: 100))
        let view2 = Mock.view(CGSize(width: 100, height: 100))
        
        let path1 = PDFfilePath("test_sample1.pdf")
        _ = try? PDFGenerator.generate(view, outputPath: path1)
        XCTAssertTrue(isExistPDF(path1))
        
        let path2 = PDFfilePath("hoge/test_sample2.pdf")
        _ = try? PDFGenerator.generate(view, outputPath: path2)
        XCTAssertFalse(isExistPDF(path2))
        
        let path3 = PDFfilePath("test_sample3.pdf")
        _ = try? PDFGenerator.generate([view, view2], outputPath: path3)
        XCTAssertTrue(isExistPDF(path3))
        
        XCTAssertNotNil(try? PDFGenerator.generate(view))
        XCTAssertNotNil(try? PDFGenerator.generate([view]))
        XCTAssertNotNil(try? PDFGenerator.generate([view, view2]))
    }
    
    // MARK: UIImage -> PDF
    func testImageToPDF() {
        let image1 = Mock.image("test_image1")
        let image2 = Mock.image("test_image1")
        
        let path1 = PDFfilePath("test_sample1.pdf")
        _ = try? PDFGenerator.generate(image1, outputPath: path1)
        XCTAssertTrue(isExistPDF(path1))
        
        let path2 = PDFfilePath("hoge/test_sample2.pdf")
        _ = try? PDFGenerator.generate(image1, outputPath: path2)
        XCTAssertFalse(isExistPDF(path2))
        
        let path3 = PDFfilePath("test_sample3.pdf")
        _ = try? PDFGenerator.generate([image1, image2], outputPath: path3)
        XCTAssertTrue(isExistPDF(path3))
        
        XCTAssertNotNil(try? PDFGenerator.generate(image1))
        XCTAssertNotNil(try? PDFGenerator.generate([image1]))
        XCTAssertNotNil(try? PDFGenerator.generate([image1, image2]))
    }
    
    // MARK: ImagePath(String) -> PDF
    func testImagePathToPDF() {
        let image1 = Mock.imagePath("test_image1")
        let image2 = Mock.imagePath("test_image1")
        
        let path1 = PDFfilePath("test_sample1.pdf")
        _ = try? PDFGenerator.generate(image1, outputPath: path1)
        XCTAssertTrue(isExistPDF(path1))
        
        let path2 = PDFfilePath("hoge/test_sample2.pdf")
        _ = try? PDFGenerator.generate(image1, outputPath: path2)
        XCTAssertFalse(isExistPDF(path2))
        
        let path3 = PDFfilePath("test_sample3.pdf")
        _ = try? PDFGenerator.generate([image1, image2], outputPath: path3)
        XCTAssertTrue(isExistPDF(path3))
        
        XCTAssertNotNil(try? PDFGenerator.generate(image1))
        XCTAssertNotNil(try? PDFGenerator.generate([image1]))
        XCTAssertNotNil(try? PDFGenerator.generate([image1, image2]))
    }
    
    // MARK: PDFPage -> PDF
    func testMixedPageToPDF() {
        let p1 = PDFPage.View(Mock.view(CGSize(width: 100, height: 100)))
        let p2 = PDFPage.Image(Mock.image(Mock.ImageName.testImage1))
        let p3 = PDFPage.ImagePath(Mock.imagePath(Mock.ImageName.testImage1))
        let p4 = PDFPage.WhitePage(CGSize(width: 100, height: 100))
        let p5 = PDFPage.ImageRef(Mock.image(Mock.ImageName.testImage1).CGImage!)
        let p6 = PDFPage.Binary(UIImagePNGRepresentation(Mock.image(Mock.ImageName.testImage1))!)
        
        let path1 = PDFfilePath("test_sample1.pdf")
        _ = try? PDFGenerator.generate(p1, outputPath: path1)
        XCTAssertTrue(isExistPDF(path1))

        let path2 = PDFfilePath("hoge/test_sample2.pdf")
        _ = try? PDFGenerator.generate(p2, outputPath: path2)
        XCTAssertFalse(isExistPDF(path2))
        
        let path3 = PDFfilePath("test_sample3.pdf")
        _ = try? PDFGenerator.generate([p1, p2, p3, p4], outputPath: path3)
        XCTAssertTrue(isExistPDF(path3))

        XCTAssertNotNil(try? PDFGenerator.generate(p1))
        XCTAssertNotNil(try? PDFGenerator.generate([p2]))
        XCTAssertNotNil(try? PDFGenerator.generate([p3, p4]))
        XCTAssertNotNil(try? PDFGenerator.generate([p5, p6]))

    }
    
    // swiftlint:disable function_body_length
    func testErrors() {
        let view = Mock.view(CGSize(width: 100, height: 100))
        let image = Mock.image(Mock.ImageName.testImage1)
        let imagePath = Mock.imagePath(Mock.ImageName.testImage1)
        let viewPage = PDFPage.View(Mock.view(CGSize(width: 100, height: 100)))
        let imagePage = PDFPage.Image(Mock.image(Mock.ImageName.testImage1))
        let imagePathPage = PDFPage.ImagePath(Mock.imagePath(Mock.ImageName.testImage1))
        let whitePage = PDFPage.WhitePage(CGSize(width: 100, height: 100))
        let views = [
            Mock.view(CGSize(width: 100, height: 100)),
            Mock.view(CGSize(width: 100, height: 100))
        ]
        let images = [
            Mock.image(Mock.ImageName.testImage1),
            Mock.image(Mock.ImageName.testImage1)
        ]
        let imagePaths = [
            Mock.imagePath(Mock.ImageName.testImage1),
            Mock.imagePath(Mock.ImageName.testImage1)
        ]
        
        let pages = [
            PDFPage.View(Mock.view(CGSize(width: 100, height: 100))),
            PDFPage.Image(Mock.image(Mock.ImageName.testImage1)),
            PDFPage.ImagePath(Mock.imagePath(Mock.ImageName.testImage1)),
            PDFPage.WhitePage(CGSize(width: 100, height: 100))
        ]

        let mocks: [Any] = [
            view,
            image,
            imagePath,
            viewPage,
            imagePage,
            imagePathPage,
            whitePage,
            views,
            images,
            imagePaths,
            pages,
        ]
        
        let emptyMocks: [Any] = [
            [UIView](),
            [UIImage](),
            [String](),
            [PDFPage]()
        ]
        
        // MARK: check EmptyOutputPath
        mocks.forEach {
            do {
                if let page = $0 as? UIView {
                    try PDFGenerator.generate(page, outputPath: "")
                } else if let page = $0 as? UIImage {
                    try PDFGenerator.generate(page, outputPath: "")
                } else if let page = $0 as? String {
                    try PDFGenerator.generate(page, outputPath: "")
                } else if let page = $0 as? PDFPage {
                    try PDFGenerator.generate(page, outputPath: "")
                } else if let pages = $0 as? [UIView] {
                    try PDFGenerator.generate(pages, outputPath: "")
                } else if let pages = $0 as? [UIImage] {
                    try PDFGenerator.generate(pages, outputPath: "")
                } else if let pages = $0 as? [String] {
                    try PDFGenerator.generate(pages, outputPath: "")
                } else if let pages = $0 as? [PDFPage] {
                    try PDFGenerator.generate(pages, outputPath: "")
                } else {
                    XCTFail("invalid page(s) type found.")
                }
                XCTFail("[\($0)] No create PDF from empty name image path.")
            } catch PDFGenerateError.EmptyOutputPath {
                // Right Error
            } catch (let e) {
                XCTFail("[\($0)] Unknown or wrong error occurred.\(e)")
            }
        }
        
        // MARK: check EmptyPage
        emptyMocks.forEach {
            do {
                let path = PDFfilePath("test_sample1.pdf")
                if let pages = $0 as? [UIView] {
                    try PDFGenerator.generate(pages, outputPath: path)
                } else if let pages = $0 as? [UIImage] {
                    try PDFGenerator.generate(pages, outputPath: path)
                } else if let pages = $0 as? [String] {
                    try PDFGenerator.generate(pages, outputPath: path)
                } else if let pages = $0 as? [PDFPage] {
                    try PDFGenerator.generate(pages, outputPath: path)
                } else {
                    XCTFail("invalid pages type found.")
                }
                XCTFail("[\($0)] No create PDF from empty name image path.")
            } catch PDFGenerateError.EmptyPage {
                // Right Error
            } catch (let e) {
                XCTFail("[\($0)] Unknown or wrong error occurred.\(e)")
            }
        }
        
        // MARK: check EmptyPage
        emptyMocks.forEach {
            do {
                if let pages = $0 as? [UIView] {
                    _ = try PDFGenerator.generate(pages)
                } else if let pages = $0 as? [UIImage] {
                    _ = try PDFGenerator.generate(pages)
                } else if let pages = $0 as? [String] {
                    _ = try PDFGenerator.generate(pages)
                } else if let pages = $0 as? [PDFPage] {
                    _ = try PDFGenerator.generate(pages)
                } else {
                    XCTFail("invalid pages type found.")
                }
                XCTFail("[\($0)] No create PDF from empty name image path.")
            } catch PDFGenerateError.EmptyPage {
                // Right Error
            } catch (let e) {
                XCTFail("[\($0)] Unknown or wrong error occurred.\(e)")
            }
        }
        

        // MARK: check ZeroSizeView
        let emptyView = Mock.view(CGSize.zero)
        do {
            let path = PDFfilePath("test_sample2.pdf")
            try PDFGenerator.generate(emptyView, outputPath: path)
        } catch PDFGenerateError.ZeroSizeView(let v) {
            XCTAssertEqual(emptyView, v)
        } catch (let e) {
            XCTFail("Unknown or wrong error occurred.\(e)")
        }
        do {
            _ = try PDFGenerator.generate(emptyView)
        } catch PDFGenerateError.ZeroSizeView(let v) {
            XCTAssertEqual(emptyView, v)
        } catch (let e) {
            XCTFail("Unknown or wrong error occurred.\(e)")
        }
        do {
            _ = try PDFGenerator.generate([emptyView])
        } catch PDFGenerateError.ZeroSizeView(let v) {
            XCTAssertEqual(emptyView, v)
        } catch (let e) {
            XCTFail("Unknown or wrong error occurred.\(e)")
        }
        
        let emptyViewPage = PDFPage.View(emptyView)
        do {
            let path = PDFfilePath("test_sample3.pdf")
            try PDFGenerator.generate(emptyViewPage, outputPath: path)
        } catch PDFGenerateError.ZeroSizeView(let v) {
            XCTAssertEqual(emptyView, v)
        } catch (let e) {
            XCTFail("Unknown or wrong error occurred.\(e)")
        }
        do {
            _ = try PDFGenerator.generate(emptyViewPage)
        } catch PDFGenerateError.ZeroSizeView(let v) {
            XCTAssertEqual(emptyView, v)
        } catch (let e) {
            XCTFail("Unknown or wrong error occurred.\(e)")
        }
        do {
            _ = try PDFGenerator.generate([emptyViewPage])
        } catch PDFGenerateError.ZeroSizeView(let v) {
            XCTAssertEqual(emptyView, v)
        } catch (let e) {
            XCTFail("Unknown or wrong error occurred.\(e)")
        }

        // MARK: check ImageLoadFailed
        let wrongImagePath = "wrong/image.png"
        do {
            let path = PDFfilePath("test_sample4.pdf")
            try PDFGenerator.generate(wrongImagePath, outputPath: path)
        } catch PDFGenerateError.ImageLoadFailed(let ip) {
            XCTAssertEqual(wrongImagePath, ip as? String)
        } catch (let e) {
            XCTFail("Unknown or wrong error occurred.\(e)")
        }
        do {
            _ = try PDFGenerator.generate(wrongImagePath)
        } catch PDFGenerateError.ImageLoadFailed(let ip) {
            XCTAssertEqual(wrongImagePath, ip as? String)
        } catch (let e) {
            XCTFail("Unknown or wrong error occurred.\(e)")
        }
        do {
            _ = try PDFGenerator.generate([wrongImagePath])
        } catch PDFGenerateError.ImageLoadFailed(let ip) {
            XCTAssertEqual(wrongImagePath, ip as? String)
        } catch (let e) {
            XCTFail("Unknown or wrong error occurred.\(e)")
        }

        let wrongImagePathPage = PDFPage.ImagePath(wrongImagePath)
        do {
            let path = PDFfilePath("test_sample5.pdf")
            try PDFGenerator.generate(wrongImagePathPage, outputPath: path)
        } catch PDFGenerateError.ImageLoadFailed(let ip) {
            XCTAssertEqual(wrongImagePath, ip as? String)
        } catch (let e) {
            XCTFail("Unknown or wrong error occurred.\(e)")
        }
        do {
            _ = try PDFGenerator.generate(wrongImagePathPage)
        } catch PDFGenerateError.ImageLoadFailed(let ip) {
            XCTAssertEqual(wrongImagePath, ip as? String)
        } catch (let e) {
            XCTFail("Unknown or wrong error occurred.\(e)")
        }
        do {
            _ = try PDFGenerator.generate([wrongImagePathPage])
        } catch PDFGenerateError.ImageLoadFailed(let ip) {
            XCTAssertEqual(wrongImagePath, ip as? String)
        } catch (let e) {
            XCTFail("Unknown or wrong error occurred.\(e)")
        }
        
        let wrongData = NSData()
        
        do {
            _ = try PDFGenerator.generate(PDFPage.Binary(wrongData))
        } catch PDFGenerateError.ImageLoadFailed(let data) {
            XCTAssertEqual(wrongData, data as? NSData)
        } catch (let e) {
            XCTFail("Unknown or wrong error occurred.\(e)")
        }

    }
    // swiftlint:enable function_body_length
    
    func testPDFPassword() {
        let view = Mock.view(CGSize(width: 100, height: 100))
        let view2 = Mock.view(CGSize(width: 100, height: 100))
        
        let path1 = PDFfilePath("test_sample1.pdf")
        _ = try? PDFGenerator.generate(view, outputPath: path1, password: "abcdef")
        XCTAssertTrue(isExistPDF(path1))
        
        let path2 = PDFfilePath("test_sample2.pdf")
        _ = try? PDFGenerator.generate(view, outputPath: path2, password: "⌘123456")
        XCTAssertFalse(isExistPDF(path2))
        
        let path3 = PDFfilePath("test_sample3.pdf")
        do {
            try PDFGenerator.generate([view, view2], outputPath: path3, password: "123456")
        } catch {
            XCTFail()
        }

        let path4 = PDFfilePath("test_sample4.pdf")
        do {
            try PDFGenerator.generate([view, view2], outputPath: path4, password: "⌘123456")
            XCTFail()
        } catch PDFGenerateError.InvalidPassword(let password) {
            XCTAssertEqual(password, "⌘123456")
        } catch {
            XCTFail()
        }

        let path5 = PDFfilePath("test_sample5.pdf")
        do {
            try PDFGenerator.generate([view, view2], outputPath: path5, password: "0123456789abcdef0123456789abcdefA")
            XCTFail()
        } catch PDFGenerateError.TooLongPassword(let length) {
            XCTAssertEqual(length, 33)
        } catch {
            XCTFail()
        }

        

        XCTAssertNotNil(try? PDFGenerator.generate(view, password: "abcdef"))
        XCTAssertNil(try? PDFGenerator.generate([view], password: "⌘123456"))
        
        do {
            _ = try PDFGenerator.generate([view], password: "123456")
        } catch {
            XCTFail()
        }

        do {
            _ = try PDFGenerator.generate([view], password: "⌘123456")
        } catch PDFGenerateError.InvalidPassword(let password) {
            XCTAssertEqual(password, "⌘123456")
        } catch {
            XCTFail()
        }
        
        do {
            _ = try PDFGenerator.generate([view], password: "0123456789abcdef0123456789abcdefA")
            XCTFail()
        } catch PDFGenerateError.TooLongPassword(let length) {
            XCTAssertEqual(length, 33)
        } catch {
            XCTFail()
        }
    }
}
