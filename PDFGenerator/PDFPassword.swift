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
    
    public init(user userPassword: String, owner ownerPassword: String) throws {
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
        
        self.userPassword = userPassword
        self.ownerPassword = ownerPassword
    }
    
    public init(_ password: String) throws {
        try self.init(user: password, owner: password)
    }
    
    func toDocumentInfo() -> [String: AnyObject] {
        var info: [String: AnyObject] = [:]
        if userPassword.characters.count > 0 {
            info[String(kCGPDFContextUserPassword)] = userPassword
        }
        if ownerPassword.characters.count > 0 {
            info[String(kCGPDFContextOwnerPassword)] = ownerPassword            
        }
        return info
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
