//
//  FilePathConvertible.swift
//  PDFGenerator
//
//  Created by Suguru Kishimoto on 7/23/16.
//
//

import Foundation

public protocol FilePathConvertible {
    var URL: NSURL? { get }
    var path: String? { get }
}

extension String: FilePathConvertible {
    public var URL: NSURL? {
        return NSURL(fileURLWithPath: self)
    }
    
    public var path: String? {
        return self
    }
}

extension NSURL: FilePathConvertible {
    public var URL: NSURL? {
        return self
    }
}
