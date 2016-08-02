//
//  PDFPage.swift
//  PDFGenerator
//
//  Created by Suguru Kishimoto on 2016/06/21.
//
//

import Foundation
import UIKit


/**
 PDF page model.
 
 - WhitePage: A white view (CGSize)
 - View:      A view. (UIView)
 - Image:     An image (UIImage)
 - ImagePath: ImagePath: An image path (String)
 - Binary:    Binary data (NSData)
 - ImageRef:  Image ref (CGImage)
 */
public enum PDFPage {
    /// A white view (CGSize)
    case WhitePage(CGSize)
    /// A view. (UIView)
    case View(UIView)
    /// An image (UIImage)
    case Image(UIImage)
    /// ImagePath: An image path (String)
    case ImagePath(String)
    /// Binary data (NSData)
    case Binary(NSData)
    /// Image ref (CGImage)
    case ImageRef(CGImage)
    
    /**
     Convert views to PDFPage models.
     
     - parameter views: Array of `UIVIew`
     
     - returns: Array of `PDFPage`
     */
    static func pages(views: [UIView]) -> [PDFPage] {
        return views.map { .View($0) }
    }
    
    /**
     Convert images to PDFPage models.
     
     - parameter views: Array of `UIImage`
     
     - returns: Array of `PDFPage`
     */
    static func pages(images: [UIImage]) -> [PDFPage] {
        return images.map { .Image($0) }
    }
    
    /**
     Convert image path to PDFPage models.
     
     - parameter views: Array of `String`(image path)
     
     - returns: Array of `PDFPage`
     */
    static func pages(imagePaths: [String]) -> [PDFPage] {
        return imagePaths.map { .ImagePath($0) }
    }
}

/// PDF page size (pixel, 72dpi)
public struct PDFPageSize {
    private init() {}
    /// A4
    public static let A4 = CGSize(width: 595.0, height: 842.0)
    /// B5
    public static let B5 = CGSize(width: 516.0, height: 729.0)
}
