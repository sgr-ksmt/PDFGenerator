//
//  PDFGeneratorTests.swift
//  PDFGeneratorTests
//
//  Created by Suguru Kishimoto on 2016/02/04.
//
//

import XCTest
@testable import PDFGenerator

class PDFGeneratorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testOutputToFile() {
        // MARK: view
        
        let view = UIView(frame: CGRectMake(0, 0, 100, 100))
        view.backgroundColor = UIColor.redColor()
        
        let path1 = NSHomeDirectory().stringByAppendingString("/test_sample1.pdf")
        try! PDFGenerator.generate(view, outputPath: path1)
        XCTAssertTrue(NSFileManager.defaultManager().fileExistsAtPath(path1))
        _ = try? NSFileManager.defaultManager().removeItemAtPath(path1)
        
        
        let wrongPath = NSHomeDirectory().stringByAppendingString("/hoge/test_sample2.pdf")
        try! PDFGenerator.generate(view, outputPath: wrongPath)
        XCTAssertFalse(NSFileManager.defaultManager().fileExistsAtPath(wrongPath))
        _ = try? NSFileManager.defaultManager().removeItemAtPath(wrongPath)
        
        let view2 = UIView(frame: CGRectMake(0, 0, 100, 100))
        view2.backgroundColor = UIColor.greenColor()
        
        let path4 = NSHomeDirectory().stringByAppendingString("/test_sample4.pdf")
        try! PDFGenerator.generate([view,view2], outputPath: path4)
        XCTAssertTrue(NSFileManager.defaultManager().fileExistsAtPath(path4))
        _ = try? NSFileManager.defaultManager().removeItemAtPath(path4)
    }
    
    func testOutputToData() {
        let view = UIView(frame: CGRectMake(0, 0, 100, 100))
        view.backgroundColor = UIColor.redColor()
        let path1 = NSHomeDirectory().stringByAppendingString("/test_sample3.pdf")
        do {
            let data = try PDFGenerator.generate(view)
            data.writeToFile(path1, atomically: true)
            XCTAssertTrue(NSFileManager.defaultManager().fileExistsAtPath(path1))
            _ = try? NSFileManager.defaultManager().removeItemAtPath(path1)
            
        } catch (let error) {
            XCTFail("\(error)")
        }
        
    }
    
    func testEmpty() {

        let view = UIView(frame: CGRectMake(0, 0, 100, 100))
        view.backgroundColor = UIColor.redColor()
        do {
            let data = try PDFGenerator.generate(view)
            XCTAssertNotEqual(data.length, 0)
        } catch (let error) {
            XCTFail("\(error)")
        }

        do {
            try PDFGenerator.generate("", outputPath: "")
            XCTFail("No create PDF from empty name image path.")
        } catch PDFGenerateError.EmptyOutputPath {
            XCTAssertTrue(true)
        } catch (let e) {
            XCTFail("Unknown error occurred.\(e)")
        }

        let path = NSHomeDirectory().stringByAppendingString("/test_empty_sample.pdf")

        do {
            try PDFGenerator.generate("", outputPath: path)
            XCTFail("No create PDF from empty name image path.")
        } catch PDFGenerateError.ImageLoadFailed(let p) {
            XCTAssertEqual(p, "")
        } catch (let e) {
            XCTFail("Wrong error : \(e)")
        }

        do {
            try PDFGenerator.generate("", outputPath: path)
            XCTFail("No create PDF from empty name image path.")
        } catch PDFGenerateError.ImageLoadFailed {
        } catch (let e) {
            XCTFail("Wrong error : \(e)")
        }
        XCTAssertFalse(NSFileManager.defaultManager().fileExistsAtPath(path))
        
        do {
            let _ = try PDFGenerator.generate("hoge")
            XCTFail()
        }  catch PDFGenerateError.ImageLoadFailed(let p) {
            XCTAssertEqual(p, "hoge")
        }catch (let error) {
            XCTFail("Wrong error : \(error)")
        }
        
    }
    
    //TODO: mixed type pdf test.
}
