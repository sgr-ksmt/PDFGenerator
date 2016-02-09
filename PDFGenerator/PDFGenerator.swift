//
//  PDFGenerator.swift
//  PDFGenerator
//
//  Created by Suguru Kishimoto on 2016/02/04.
//
//

import Foundation
import UIKit


public enum PDFPage {
    case View(UIView)
    case Image(UIImage)
    case ImagePath(String)
}

public enum PDFGenerateError: ErrorType {
    case ImageLoadFailed
}

internal extension PDFPage {
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

/// PDFGenerator
public final class PDFGenerator {
    
    private typealias Process = () throws -> Void
    private init() {}
    
    public class func generate(page: PDFPage, outputPath: String) throws {
        try generate([page], outputPath: outputPath)
    }
    
    public class func generate(pages: [PDFPage], outputPath: String) throws {
        do {
            try outputToFile(outputPath) {
                try renderPages(pages)
            }
        } catch (let e) {
            _ = try? NSFileManager.defaultManager().removeItemAtPath(outputPath)
            throw e
        }
    }

    public class func generate(page: PDFPage) throws -> NSData {
        return try generate([page])
    }

    public class func generate(pages: [PDFPage]) throws -> NSData {
        return try outputToData {
            try renderPages(pages)
        }
    }

    
    /**
     Generate PDF file from single view.
     
     - parameter view: An `UIView` and `UIView's` subclass instance.
     - parameter outputPath: A Path to write PDF file.
     */
    public class func generate(view: UIView, outputPath: String) {
        generate([view],outputPath: outputPath)
    }

    /**
     Generate PDF file from views.
     
     - parameter views: Array of `UIView` and `UIView's` subclass.
     - parameter outputPath: A Path to write PDF file.
     */
    public class func generate(views: [UIView], outputPath: String) {
        try! generate(PDFPage.pages(views), outputPath: outputPath)
    }
    
    /**
     Generate PDF file as row data(`NSData`) from single view.
     
     - parameter view: An `UIView` and `UIView's` subclass instance.
     
     - returns: A data of PDF file's.(`NSData`)
     */
    public class func generate(view: UIView) -> NSData {
        return generate([view])
    }

    /**
     Generate PDF file as row data(`NSData`) from views.
     
     - parameter views: Array of `UIView` and `UIView's` subclass.
     
     - returns: A data of PDF file's.(`NSData`)
     */
    public class func generate(views: [UIView]) -> NSData {
        return try! generate(PDFPage.pages(views))
    }
    
    /**
     Generate PDF file from single image.
     
     - parameter image: An image.
     - parameter outputPath: A Path to write PDF file.
     */
    public class func generate(image: UIImage, outputPath: String) {
        generate([image], outputPath: outputPath)
    }
    
    /**
     Generate PDF file from images.
     
     - parameter image: Array of image.
     - parameter outputPath: A Path to write PDF file
     */
    public class func generate(images: [UIImage], outputPath: String) {
        try! generate(PDFPage.pages(images), outputPath: outputPath)
    }
    
    /**
     Generate PDF file as row data(`NSData`) from single image.
     
     - parameter image: An image.
     
     - returns: A data of PDF file's.(`NSData`)
     */
    public class func generate(image: UIImage) -> NSData {
        return generate([image])
    }

    /**
     Generate PDF file as row data(`NSData`) from images
     
     - parameter image: Array of image.
     
     - returns: A data of PDF file's.(`NSData`)
     */
    public class func generate(images: [UIImage]) -> NSData {
        return try! generate(PDFPage.pages(images))
    }
    
    /**
     Generate PDF file from single image path
     
     - parameter imagePath: An image path.
     - parameter outputPath: A Path to write PDF file.
     */
    public class func generate(imagePath: String, outputPath: String) throws {
        try generate([imagePath], outputPath: outputPath)
    }

    /**
     Generate PDF file from image paths
     
     - parameter imagePaths: Array of image path.
     - parameter outputPath: A Path to write PDF file.
     */
    public class func generate(imagePaths: [String], outputPath: String) throws {
        try generate(PDFPage.pages(imagePaths), outputPath: outputPath)
    }
    
    /**
     Generate PDF file as row data(`NSData`) from single image path.
     
     - parameter imagePath: An image path.
     
     - returns: A data of PDF file's.(`NSData`)
     */
    public class func generate(imagePath: String) throws -> NSData {
        return try generate([imagePath])
    }
    
    /**
     Generate PDF file as row data(`NSData`) from image paths
     
     - parameter image: Array of image path.
     
     - returns: A data of PDF file's.(`NSData`)
     */
    public class func generate(imagePaths: [String]) throws -> NSData {
        return try generate(PDFPage.pages(imagePaths))
    }
    
    private class func renderPage(page: PDFPage) throws {
        switch page {
        case .View(let v): v.renderPDFPage()
        case .Image(let i): i.renderPDFPage()
        case .ImagePath(let ip):
            guard NSFileManager.defaultManager().fileExistsAtPath(ip) else{
                throw PDFGenerateError.ImageLoadFailed
            }
            autoreleasepool {
                ip.to_image().renderPDFPage()
            }
        }
    }
    
    private class func renderPages(pages: [PDFPage]) throws {
        try pages.forEach {
            try renderPage($0)
        }
    }

    private class func outputToFile(outputPath: String, process: Process) rethrows {
        UIGraphicsBeginPDFContextToFile(outputPath, CGRectZero, nil)
        try process()
        UIGraphicsEndPDFContext()
    }
    
    private class func outputToData(process: Process) rethrows -> NSData {
        let data = NSMutableData()
        UIGraphicsBeginPDFContextToData(data, CGRectZero, nil)
        try process()
        UIGraphicsEndPDFContext()
        return data
    }
    
}