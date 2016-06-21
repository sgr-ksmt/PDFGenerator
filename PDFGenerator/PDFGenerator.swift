//
//  PDFGenerator.swift
//  PDFGenerator
//
//  Created by Suguru Kishimoto on 2016/02/04.
//
//

import Foundation
import UIKit

/// PDFGenerator
public final class PDFGenerator {
    private typealias Process = () throws -> Void
    
    /// Avoid creating instance.
    private init() {}
    
    /**
     Generate from page object.
     
     - parameter page:       A `PDFPage`'s object.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(page: PDFPage, outputPath: String, dpi: DPIType = .Default) throws {
        try generate([page], outputPath: outputPath, dpi: dpi)
    }
    
    /**
     Generate from page objects.
     
     - parameter pages:      Array of `PDFPage`'s objects.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(pages: [PDFPage], outputPath: String, dpi: DPIType = .Default) throws {
        guard !pages.isEmpty else {
            throw PDFGenerateError.EmptyPage
        }
        guard !outputPath.isEmpty else {
            throw PDFGenerateError.EmptyOutputPath
        }
        do {
            try outputToFile(outputPath) {
                try renderPages(pages, dpi: dpi)
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
    public class func generate(view: UIView, outputPath: String, dpi: DPIType = .Default) throws {
        try generate([view],outputPath: outputPath, dpi: dpi)
    }
    

    /**
     Generate from views.
     
     - parameter views:      Array of views.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(views: [UIView], outputPath: String, dpi: DPIType = .Default) throws {
        try generate(PDFPage.pages(views), outputPath: outputPath, dpi: dpi)
    }
    
    /**
     Generate from image.
     
     - parameter image:      An image.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(image: UIImage, outputPath: String, dpi: DPIType = .Default) throws {
        try generate([image], outputPath: outputPath, dpi: dpi)
    }
    
    /**
     Generate from images.
     
     - parameter images:     Array of images.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(images: [UIImage], outputPath: String, dpi: DPIType = .Default) throws {
        try generate(PDFPage.pages(images), outputPath: outputPath, dpi: dpi)
    }

    /**
     Generate from image path.
     
     - parameter imagePath:  An image path.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(imagePath: String, outputPath: String, dpi: DPIType = .Default) throws {
        try generate([imagePath], outputPath: outputPath, dpi: dpi)
    }
    
    /**
     Generate from image paths.
     
     - parameter imagePaths: Arrat of image paths.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(imagePaths: [String], outputPath: String, dpi: DPIType = .Default) throws {
        try generate(PDFPage.pages(imagePaths), outputPath: outputPath, dpi: dpi)
    }
    
    
    /**
     Generate from page object.
     
     - parameter page: A `PDFPage`'s object.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(page: PDFPage, dpi: DPIType = .Default) throws -> NSData {
        return try generate([page], dpi: dpi)
    }

    /**
     Generate from page objects.
     
     - parameter pages: Array of `PDFPage`'s objects.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(pages: [PDFPage], dpi: DPIType = .Default) throws -> NSData {
        guard !pages.isEmpty else {
            throw PDFGenerateError.EmptyPage
        }
        return try outputToData { try renderPages(pages, dpi: dpi) }
    }

    /**
     Generate from view.
     
     - parameter view: A view
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(view: UIView, dpi: DPIType = .Default) throws -> NSData {
        return try generate([view], dpi: dpi)
    }

    /**
     Generate from views.
     
     - parameter views: Array of views.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(views: [UIView], dpi: DPIType = .Default) throws -> NSData  {
        return try generate(PDFPage.pages(views), dpi: dpi)
    }
    
    /**
     Generate from image.
     
     - parameter image: An image.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(image: UIImage, dpi: DPIType = .Default) throws -> NSData {
        return try generate([image], dpi: dpi)
    }

    /**
     Generate from images.
     
     - parameter images: Array of images.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(images: [UIImage], dpi: DPIType = .Default) throws -> NSData {
        return try generate(PDFPage.pages(images), dpi: dpi)
    }
    
    /**
     Generate from image path.
     
     - parameter imagePath: An image path.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(imagePath: String, dpi: DPIType = .Default) throws -> NSData {
        return try generate([imagePath], dpi: dpi)
    }
    
    /**
     Generate from image paths.
     
     - parameter imagePaths: Arrat of image paths.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(imagePaths: [String], dpi: DPIType = .Default) throws -> NSData {
        return try generate(PDFPage.pages(imagePaths), dpi: dpi)
    }
}

// MARK: Private Extension

/// PDFGenerator private extensions (render processes)
private extension PDFGenerator {
    class func renderPage(page: PDFPage, dpi: DPIType) throws {
        
        /// Inner function
        func renderImage(imageConvertible: UIImageConvertible) throws {
            try imageConvertible.to_image().renderPDFPage()
        }
        
        try autoreleasepool {
            switch page {
            case .WhitePage(let size):
                let view = UIView(frame: CGRect(origin: .zero, size: size))
                view.backgroundColor = .whiteColor()
                try view.renderPDFPage()
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
    }
    
    class func renderPages(pages: [PDFPage], dpi: DPIType) throws {
        try pages.forEach { try renderPage($0, dpi: dpi) }
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