//
//  FilePathConvertibleTest.swift
//  PDFGenerator
//
//  Created by Suguru Kishimoto on 7/23/16.
//
//

import XCTest
import PDFGenerator

class FilePathConvertibleTest: XCTestCase {
    
    
    func test() {
        let p1: FilePathConvertible = ""
        XCTAssertNil(p1.URL)
        XCTAssertEqual(p1.path, "")
        XCTAssertEqual(p1.URL, NSURL(fileURLWithPath: ""))

        let p2: FilePathConvertible = "path/to/hoge.txt"
        XCTAssertNotNil(p2.URL)
        XCTAssertEqual(p2.URL, NSURL(fileURLWithPath: "path/to/hoge.txt"))
        XCTAssertEqual(p2.path, "path/to/hoge.txt")

        let p3: FilePathConvertible = NSURL(fileURLWithPath: "path/to/hoge.txt")
        XCTAssertNotNil(p3.URL)
        XCTAssertEqual(p3.URL, NSURL(fileURLWithPath: "path/to/hoge.txt"))
    }
}
