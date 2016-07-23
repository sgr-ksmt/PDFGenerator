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
    public class func generate(page: PDFPage, outputPath: FilePathConvertible, dpi: DPIType = .Default, password: PDFPassword = "") throws {
        try generate([page], outputPath: outputPath, dpi: dpi, password: password)
    }
    
    /**
     Generate from page objects.
     
     - parameter pages:      Array of `PDFPage`'s objects.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(pages: [PDFPage], outputPath: FilePathConvertible, dpi: DPIType = .Default, password: PDFPassword = "") throws {
        guard !pages.isEmpty else {
            throw PDFGenerateError.EmptyPage
        }
        guard let outputURL = outputPath.URL, outputPathString = outputPath.path else {
            throw PDFGenerateError.EmptyOutputPath
        }
        do {
            try outputToFile(outputPathString, password: password) {
                try renderPages(pages, dpi: dpi)
            }
        } catch (let error) {
            _ = try? NSFileManager.defaultManager().removeItemAtURL(outputURL)
            throw error
        }
    }
    
    /**
     Generate from view.
     
     - parameter view:       A view
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(view: UIView, outputPath: FilePathConvertible, dpi: DPIType = .Default, password: PDFPassword = "") throws {
        try generate([view], outputPath: outputPath, dpi: dpi, password: password)
    }
    

    /**
     Generate from views.
     
     - parameter views:      Array of views.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(views: [UIView], outputPath: FilePathConvertible, dpi: DPIType = .Default, password: PDFPassword = "") throws {
        try generate(PDFPage.pages(views), outputPath: outputPath, dpi: dpi, password: password)
    }
    
    /**
     Generate from image.
     
     - parameter image:      An image.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(image: UIImage, outputPath: FilePathConvertible, dpi: DPIType = .Default, password: PDFPassword = "") throws {
        try generate([image], outputPath: outputPath, dpi: dpi, password: password)
    }
    
    /**
     Generate from images.
     
     - parameter images:     Array of images.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(images: [UIImage], outputPath: FilePathConvertible, dpi: DPIType = .Default, password: PDFPassword = "") throws {
        try generate(PDFPage.pages(images), outputPath: outputPath, dpi: dpi, password: password)
    }

    /**
     Generate from image path.
     
     - parameter imagePath:  An image path.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(imagePath: String, outputPath: FilePathConvertible, dpi: DPIType = .Default, password: PDFPassword = "") throws {
        try generate([imagePath], outputPath: outputPath, dpi: dpi, password: password)
    }
    
    /**
     Generate from image paths.
     
     - parameter imagePaths: Arrat of image paths.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(imagePaths: [String], outputPath: FilePathConvertible, dpi: DPIType = .Default, password: PDFPassword = "") throws {
        try generate(PDFPage.pages(imagePaths), outputPath: outputPath, dpi: dpi, password: password)
    }
    
    
    /**
     Generate from page object.
     
     - parameter page: A `PDFPage`'s object.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(page: PDFPage, dpi: DPIType = .Default, password: PDFPassword = "") throws -> NSData {
        return try generate([page], dpi: dpi, password: password)
    }

    /**
     Generate from page objects.
     
     - parameter pages: Array of `PDFPage`'s objects.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(pages: [PDFPage], dpi: DPIType = .Default, password: PDFPassword = "") throws -> NSData {
        guard !pages.isEmpty else {
            throw PDFGenerateError.EmptyPage
        }
        return try outputToData(password: password) { try renderPages(pages, dpi: dpi) }
    }

    /**
     Generate from view.
     
     - parameter view: A view
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(view: UIView, dpi: DPIType = .Default, password: PDFPassword = "") throws -> NSData {
        return try generate([view], dpi: dpi, password: password)
    }

    /**
     Generate from views.
     
     - parameter views: Array of views.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(views: [UIView], dpi: DPIType = .Default, password: PDFPassword = "") throws -> NSData  {
        return try generate(PDFPage.pages(views), dpi: dpi, password: password)
    }
    
    /**
     Generate from image.
     
     - parameter image: An image.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(image: UIImage, dpi: DPIType = .Default, password: PDFPassword = "") throws -> NSData {
        return try generate([image], dpi: dpi, password: password)
    }

    /**
     Generate from images.
     
     - parameter images: Array of images.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(images: [UIImage], dpi: DPIType = .Default, password: PDFPassword = "") throws -> NSData {
        return try generate(PDFPage.pages(images), dpi: dpi, password: password)
    }
    
    /**
     Generate from image path.
     
     - parameter imagePath: An image path.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(imagePath: String, dpi: DPIType = .Default, password: PDFPassword = "") throws -> NSData {
        return try generate([imagePath], dpi: dpi, password: password)
    }
    
    /**
     Generate from image paths.
     
     - parameter imagePaths: Arrat of image paths.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(imagePaths: [String], dpi: DPIType = .Default, password: PDFPassword = "") throws -> NSData {
        return try generate(PDFPage.pages(imagePaths), dpi: dpi, password: password)
    }
}

// MARK: Private Extension

/// PDFGenerator private extensions (render processes)
private extension PDFGenerator {
    class func renderPage(page: PDFPage, dpi: DPIType) throws {
        let scaleFactor: CGFloat = dpi.value / DPIType.Default.value
        /// Inner function
        func renderImage(imageConvertible: UIImageConvertible) throws {
            try imageConvertible.to_image().renderPDFPage(scaleFactor)
        }
        
        try autoreleasepool {
            switch page {
            case .WhitePage(let size):
                let view = UIView(frame: CGRect(origin: .zero, size: size))
                view.backgroundColor = .whiteColor()
                try view.renderPDFPage(scaleFactor)
            case .View(let view):
                try view.renderPDFPage(scaleFactor)
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
    
    class func outputToFile(outputPath: String, password: PDFPassword, process: Process) rethrows {
        try { try password.verify() }()
        UIGraphicsBeginPDFContextToFile(outputPath, .zero, password.toDocumentInfo())
        defer { UIGraphicsEndPDFContext() }
        try process()
    }
    
    class func outputToData(password password: PDFPassword, process: Process) rethrows -> NSData {
        try { try password.verify() }()
        let data = NSMutableData()
        UIGraphicsBeginPDFContextToData(data, .zero, password.toDocumentInfo())
        defer { UIGraphicsEndPDFContext() }
        try process()
        return data
    }
}
