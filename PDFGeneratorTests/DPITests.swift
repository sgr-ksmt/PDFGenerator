//
//  DPITests.swift
//  PDFGenerator
//
//  Created by Suguru Kishimoto on 7/23/16.
//
//

import XCTest
import PDFGenerator

class DPITests: XCTestCase {
    func test() {
        XCTAssertEqual(DPIType.Default.value, 72.0)
        XCTAssertEqual(DPIType.DPI_300.value, 300.0)
        XCTAssertEqual(DPIType.Custom(100.0).value, 100.0)
        XCTAssertEqual(DPIType.Custom(-100.0).value, DPIType.Default.value)
    }
}
