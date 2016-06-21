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
 PDFPage type
 
 - WhitePage: A white view (CGSize).
 - View:      A view. (UIView)
 - Image:     An image (UIImage)
 - ImagePath: An image path (String)
 */
public enum PDFPage {
    case WhitePage(CGSize)
    case View(UIView)
    case Image(UIImage)
    case ImagePath(String)
    case Binary(NSData)
    case ImageRef(CGImage)
    
    static func pages(views: [UIView]) -> [PDFPage] {
        return views.map { .View($0) }
    }
    static func pages(images: [UIImage]) -> [PDFPage] {
        return images.map { .Image($0) }
    }
    static func pages(imagePaths: [String]) -> [PDFPage] {
        return imagePaths.map { .ImagePath($0) }
    }
}
