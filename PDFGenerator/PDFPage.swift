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
    case whitePage(CGSize)
    /// A view. (UIView)
    case view(UIView)
    /// An area of a view. (UIView)
    case viewArea(UIView, area: CGRect)
    /// An image (UIImage)
    case image(UIImage)
    /// ImagePath: An image path (String)
    case imagePath(String)
    /// Binary data (NSData)
    case binary(Data)
    /// Image ref (CGImage)
    case imageRef(CGImage)

    /**
     Convert views to PDFPage models.
     
     - parameter views: Array of `UIVIew`
     
     - returns: Array of `PDFPage`
     */
    static func pages(_ views: [UIView]) -> [PDFPage] {
        return views.map { .view($0) }
    }

    /**
     Convert images to PDFPage models.
     
     - parameter views: Array of `UIImage`
     
     - returns: Array of `PDFPage`
     */
    static func pages(_ images: [UIImage]) -> [PDFPage] {
        return images.map { .image($0) }
    }

    /**
     Convert image path to PDFPage models.
     
     - parameter views: Array of `String`(image path)
     
     - returns: Array of `PDFPage`
     */
    static func pages(_ imagePaths: [String]) -> [PDFPage] {
        return imagePaths.map { .imagePath($0) }
    }

    /**
     Convert a scrollview into different pages with a given configuration
     
     - parameter scrollview: the `UIScrollView` that should be rendered
     
     - parameter configuration: a `PDFPagedScrollViewConfiguration` including the overlapPercentage and the ratio (format) of the Page
     
     - returns: Array of `PDFPage`
     */
    public static func pages(_ scrollView: UIScrollView, configuration: PDFPagedScrollViewConfiguration = PDFPagedScrollViewConfiguration(overlapPercentage: 0.10, ratio: .dinA4)) -> [PDFPage] {
        let contentSize = scrollView.contentSize
        let height = contentSize.width / configuration.ratio.rawValue
        let overlapPercentage = configuration.overlapPercentage > 0 && configuration.overlapPercentage < 1 ? configuration.overlapPercentage : 0

        var currentOffset: CGFloat = 0
        var areas: [CGRect] = []

        while currentOffset < contentSize.height {
            let area = CGRect(x: 0, y: currentOffset, width: contentSize.width, height: height)
            areas.append(area)
            currentOffset += height - height * overlapPercentage
        }
        return areas.map { .viewArea(scrollView, area: $0) }
    }
}

/// PDF page size (pixel, 72dpi)
public struct PDFPageSize {
    fileprivate init() { }
    /// A4
    public static let A4 = CGSize(width: 595.0, height: 842.0)
    /// A5
    public static let A5 = CGSize(width: 420.0, height: 595.0)
    ///A6
    public static let A6 = CGSize(width: 298.0, height: 420.0)
    /// B5
    public static let B5 = CGSize(width: 516.0, height: 729.0)
}
