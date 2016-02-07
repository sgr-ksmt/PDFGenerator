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
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOutput() {
        let view = UIView(frame: CGRectMake(0, 0, 100, 100))
        view.backgroundColor = UIColor.redColor()
        
        let path1 = NSHomeDirectory().stringByAppendingString("/test_sample1.pdf")
        PDFGenerator.generate(view, outputPath: path1)
        XCTAssertTrue(NSFileManager.defaultManager().fileExistsAtPath(path1))
        _ = try? NSFileManager.defaultManager().removeItemAtPath(path1)
        
        
        let wrongPath = NSHomeDirectory().stringByAppendingString("/hoge/test_sample2.pdf")
        PDFGenerator.generate(view, outputPath: wrongPath)
        XCTAssertFalse(NSFileManager.defaultManager().fileExistsAtPath(wrongPath))
        _ = try? NSFileManager.defaultManager().removeItemAtPath(wrongPath)

        
        let path3 = NSHomeDirectory().stringByAppendingString("/test_sample3.pdf")
        let data = PDFGenerator.generate(view)
        data.writeToFile(path3, atomically: true)
        XCTAssertTrue(NSFileManager.defaultManager().fileExistsAtPath(path3))
        _ = try? NSFileManager.defaultManager().removeItemAtPath(path3)

        let view2 = UIView(frame: CGRectMake(0, 0, 100, 100))
        view2.backgroundColor = UIColor.greenColor()
        
        let path4 = NSHomeDirectory().stringByAppendingString("/test_sample4.pdf")
        PDFGenerator.generate([view,view2], outputPath: path4)
        XCTAssertTrue(NSFileManager.defaultManager().fileExistsAtPath(path4))
        _ = try? NSFileManager.defaultManager().removeItemAtPath(path4)

        
    }
    
    func testEmpty() {

        let emptyData = NSMutableData()
        UIGraphicsBeginPDFContextToData(emptyData, CGRectZero, nil)
        UIGraphicsEndPDFContext()
        
        let view = UIView(frame: CGRectMake(0, 0, 100, 100))
        view.backgroundColor = UIColor.redColor()
        let data1 = PDFGenerator.generate(view)
        XCTAssertNotEqual(data1.length, emptyData.length)
        
        let data2 = PDFGenerator.generate("")
        XCTAssertEqual(data2.length, emptyData.length)
        
        
    }
    
}
