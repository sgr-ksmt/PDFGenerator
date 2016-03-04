//
//  PDFGenerator.swift
//  PDFGenerator
//
//  Created by Suguru Kishimoto on 2016/02/04.
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


/**
 PDFGenerateError
 
 - ZeroSizeView:    View's size is (0, 0)
 - ImageLoadFailed: Image has not been loaded from image path.
 - EmptyOutputPath: Output path is empty.
 - EmptyPage:       Create PDF from no pages.
 */
public enum PDFGenerateError: ErrorType {
    case ZeroSizeView(UIView)
    case ImageLoadFailed(AnyObject)
    case EmptyOutputPath
    case EmptyPage
}

/// PDFGenerator
public final class PDFGenerator {
    private typealias Process = () throws -> Void
    
    private init() {}
    
    /**
     Generate from page object.
     
     - parameter page:       A `PDFPage`'s object.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(page: PDFPage, outputPath: String) throws {
        try generate([page], outputPath: outputPath)
    }
    
    /**
     Generate from page objects.
     
     - parameter pages:      Array of `PDFPage`'s objects.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(pages: [PDFPage], outputPath: String) throws {
        guard !pages.isEmpty else {
            throw PDFGenerateError.EmptyPage
        }
        guard !outputPath.isEmpty else {
            throw PDFGenerateError.EmptyOutputPath
        }
        do {
            try outputToFile(outputPath) {
                try renderPages(pages)
            }
        } catch (let error) {
            _ = try? NSFileManager.defaultManager().removeItemAtPath(outputPath)
            throw error
        }
    }
    
    /**
     Generate from view.
     
     - parameter view:       A view
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(view: UIView, outputPath: String) throws {
        try generate([view],outputPath: outputPath)
    }
    

    /**
     Generate from views.
     
     - parameter views:      Array of views.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(views: [UIView], outputPath: String) throws {
        try generate(PDFPage.pages(views), outputPath: outputPath)
    }
    
    /**
     Generate from image.
     
     - parameter image:      An image.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(image: UIImage, outputPath: String) throws {
        try generate([image], outputPath: outputPath)
    }
    
    /**
     Generate from images.
     
     - parameter images:     Array of images.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(images: [UIImage], outputPath: String) throws {
        try generate(PDFPage.pages(images), outputPath: outputPath)
    }

    /**
     Generate from image path.
     
     - parameter imagePath:  An image path.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(imagePath: String, outputPath: String) throws {
        try generate([imagePath], outputPath: outputPath)
    }
    
    /**
     Generate from image paths.
     
     - parameter imagePaths: Arrat of image paths.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(imagePaths: [String], outputPath: String) throws {
        try generate(PDFPage.pages(imagePaths), outputPath: outputPath)
    }
    
    
    /**
     Generate from page object.
     
     - parameter page: A `PDFPage`'s object.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(page: PDFPage) throws -> NSData {
        return try generate([page])
    }

    /**
     Generate from page objects.
     
     - parameter pages: Array of `PDFPage`'s objects.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(pages: [PDFPage]) throws -> NSData {
        guard !pages.isEmpty else {
            throw PDFGenerateError.EmptyPage
        }
        return try outputToData { try renderPages(pages) }
    }

    /**
     Generate from view.
     
     - parameter view: A view
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(view: UIView) throws -> NSData {
        return try generate([view])
    }

    /**
     Generate from views.
     
     - parameter views: Array of views.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(views: [UIView]) throws -> NSData  {
        return try generate(PDFPage.pages(views))
    }
    
    /**
     Generate from image.
     
     - parameter image: An image.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(image: UIImage) throws -> NSData {
        return try generate([image])
    }

    /**
     Generate from images.
     
     - parameter images: Array of images.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(images: [UIImage]) throws -> NSData {
        return try generate(PDFPage.pages(images))
    }
    
    /**
     Generate from image path.
     
     - parameter imagePath: An image path.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(imagePath: String) throws -> NSData {
        return try generate([imagePath])
    }
    
    /**
     Generate from image paths.
     
     - parameter imagePaths: Arrat of image paths.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(imagePaths: [String]) throws -> NSData {
        return try generate(PDFPage.pages(imagePaths))
    }
}

// MARK: - PDFGenerator private extensions (render processes)
private extension PDFGenerator {
    class func renderPage(page: PDFPage) throws {
        
        func renderImage(imageConvertible: UIImageConvertible) throws {
            try autoreleasepool {
                try imageConvertible.to_image().renderPDFPage()
            }
        }
        switch page {
        case .WhitePage(let size):
            try autoreleasepool {
                let view = UIView(frame: CGRect(origin: .zero, size: size))
                view.backgroundColor = .whiteColor()
                try view.renderPDFPage()
            }
        case .View(let view):
            try view.renderPDFPage()
        case .Image(let image):
            try renderImage(image)
        case .ImagePath(let ip):
            try renderImage(ip)
        case .Binary(let data):
            try renderImage(data)
        case .ImageRef(let cgImage):
            try renderImage(cgImage)
        }
    }
    
    class func renderPages(pages: [PDFPage]) throws {
        try pages.forEach(renderPage)
    }
    
    class func outputToFile(outputPath: String, process: Process) rethrows {
        UIGraphicsBeginPDFContextToFile(outputPath, .zero, nil)
        defer {
            UIGraphicsEndPDFContext()
        }
        try process()
    }
    
    class func outputToData(process: Process) rethrows -> NSData {
        let data = NSMutableData()
        UIGraphicsBeginPDFContextToData(data, .zero, nil)
        defer {
            UIGraphicsEndPDFContext()
        }
        try process()
        return data
    }
}