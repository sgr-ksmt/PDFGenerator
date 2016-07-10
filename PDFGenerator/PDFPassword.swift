//
//  PDFPassword.swift
//  PDFGenerator
//
//  Created by Suguru Kishimoto on 2016/07/08.
//
//

import Foundation

public struct PDFPassword {
    static let NoPassword = ""
    
    let userPassword: String
    let ownerPassword: String
    
    public init(user userPassword: String, owner ownerPassword: String) throws {
        guard userPassword.canBeConvertedToEncoding(NSASCIIStringEncoding) else {
            throw PDFGenerateError.InvalidPassword(userPassword)
        }
        guard ownerPassword.canBeConvertedToEncoding(NSASCIIStringEncoding) else {
            throw PDFGenerateError.InvalidPassword(ownerPassword)
        }
        self.userPassword = userPassword
        self.ownerPassword = ownerPassword
    }
    
    public init(_ password: String) throws {
        try self.init(user: password, owner: password)
    }
}

extension PDFPassword: StringLiteralConvertible {
    public init(unicodeScalarLiteral value: String) {
        do {
            try self.init(value)
        } catch {
            try! self.init(self.dynamicType.NoPassword)
        }
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        do {
            try self.init(value)
        } catch {
            try! self.init(self.dynamicType.NoPassword)
        }
    }
    
    public init(stringLiteral value: String) {
        do {
            try self.init(value)
        } catch {
            try! self.init(self.dynamicType.NoPassword)
        }
    }
}
