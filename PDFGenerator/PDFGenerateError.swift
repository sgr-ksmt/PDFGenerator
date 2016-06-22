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
 */
public enum PDFGenerateError: ErrorProtocol {
    /// View's size is (0, 0)
    case zeroSizeView(UIView)
    /// Image has not been loaded from image path.
    case imageLoadFailed(AnyObject)
    /// Output path is empty
    case emptyOutputPath
    /// Attempt to create empty PDF. (no pages.)
    case emptyPage
    /// If UIGraphicsGetCurrentContext returns nil.
    case invalidContext
    
    /// If rendering scale factor is zero.
    case invalidScaleFactor
}
