//
//  AutoreleasepoolTry.swift
//  PDFGenerator
//
//  Created by Suguru Kishimoto on 2016/02/10.
//
//

import Foundation


public func autoreleasepool(code: @noescape() throws -> ()) rethrows {
    try {
        var error: ErrorProtocol?
        autoreleasepool {
            do {
                try code()
            } catch (let e) {
                error = e
            }
        }
        if let error = error {
            throw error
        }
    }()
}
