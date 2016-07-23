//
//  FilePathConvertible.swift
//  PDFGenerator
//
//  Created by Suguru Kishimoto on 7/23/16.
//
//

import Foundation

public protocol FilePathConveritble {
    var URL: NSURL { get }
}

extension String: FilePathConveritble {
    public var URL: NSURL {
        return NSURL(fileURLWithPath: self)
    }
}

extension NSURL: FilePathConveritble {
    public var URL: NSURL {
        return self
    }
}