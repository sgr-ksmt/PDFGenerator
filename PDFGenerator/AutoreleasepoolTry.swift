//
//  AutoreleasepoolTry.swift
//  PDFGenerator
//
//  Created by Suguru Kishimoto on 2016/02/10.
//
//

import Foundation


public func autoreleasepool(@noescape code: () throws -> ()) rethrows {
    try {
        var error: ErrorType?
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
