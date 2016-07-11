//
//  PDFGenerateError.swift
//  PDFGenerator
//
//  Created by Suguru Kishimoto on 2016/06/21.
//
//

import Foundation

/**
 PDFGenerateError
 
 - ZeroSizeView:    View's size is (0, 0)
 - ImageLoadFailed: Image has not been loaded from image path.
 - EmptyOutputPath: Output path is empty.
 - EmptyPage:       Create PDF from no pages.
 - InvalidContext:  If UIGraphicsGetCurrentContext returns nil.
 - InvalidPassword: If password cannot covert ASCII text.
 - TooLongPassword: If password too long
 */
public enum PDFGenerateError: ErrorType {
    /// View's size is (0, 0)
    case ZeroSizeView(UIView)
    /// Image has not been loaded from image path.
    case ImageLoadFailed(AnyObject)
    /// Output path is empty
    case EmptyOutputPath
    /// Attempt to create empty PDF. (no pages.)
    case EmptyPage
    /// If UIGraphicsGetCurrentContext returns nil.
    case InvalidContext
    /// If rendering scale factor is zero.
    case InvalidScaleFactor
    /// If password cannot covert ASCII text.
    case InvalidPassword(String)
    /// If password too long
    case TooLongPassword(Int)
}
