//
//  PDFPassword.swift
//  PDFGenerator
//
//  Created by Suguru Kishimoto on 2016/07/08.
//
//

import Foundation
import UIKit

public struct PDFPassword {
    static let NoPassword = ""
    private static let PasswordLengthMax = 32
    let userPassword: String
    let ownerPassword: String
    
    public init(user userPassword: String, owner ownerPassword: String) {
        self.userPassword = userPassword
        self.ownerPassword = ownerPassword
    }
    
    public init(_ password: String) {
        self.init(user: password, owner: password)
    }
    
    func toDocumentInfo() -> [String: AnyObject] {
        var info: [String: AnyObject] = [:]
        if userPassword != self.dynamicType.NoPassword {
            info[String(kCGPDFContextUserPassword)] = userPassword
        }
        if ownerPassword != self.dynamicType.NoPassword {
            info[String(kCGPDFContextOwnerPassword)] = ownerPassword
        }
        return info
    }
    
    func verify() throws {
        guard userPassword.canBeConvertedToEncoding(NSASCIIStringEncoding) else {
            throw PDFGenerateError.InvalidPassword(userPassword)
        }
        guard userPassword.characters.count <= self.dynamicType.PasswordLengthMax else {
            throw PDFGenerateError.TooLongPassword(userPassword.characters.count)
        }
        
        guard ownerPassword.canBeConvertedToEncoding(NSASCIIStringEncoding) else {
            throw PDFGenerateError.InvalidPassword(ownerPassword)
        }
        guard ownerPassword.characters.count <= self.dynamicType.PasswordLengthMax else {
            throw PDFGenerateError.TooLongPassword(ownerPassword.characters.count)
        }
    }
}

extension PDFPassword: StringLiteralConvertible {
    public init(unicodeScalarLiteral value: String) {
        self.init(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }
    
    public init(stringLiteral value: String) {
        self.init(value)
    }
}
