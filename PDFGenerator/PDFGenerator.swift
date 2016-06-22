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
    public class func generate(_ page: PDFPage, outputPath: String, dpi: DPIType = .default) throws {
        try generate([page], outputPath: outputPath, dpi: dpi)
    }
    
    /**
     Generate from page objects.
     
     - parameter pages:      Array of `PDFPage`'s objects.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(_ pages: [PDFPage], outputPath: String, dpi: DPIType = .default) throws {
        guard !pages.isEmpty else {
            throw PDFGenerateError.emptyPage
        }
        guard !outputPath.isEmpty else {
            throw PDFGenerateError.emptyOutputPath
        }
        do {
            try outputToFile(outputPath) {
                try renderPages(pages, dpi: dpi)
            }
        } catch (let error) {
            _ = try? FileManager.default().removeItem(atPath: outputPath)
            throw error
        }
    }
    
    /**
     Generate from view.
     
     - parameter view:       A view
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(_ view: UIView, outputPath: String, dpi: DPIType = .default) throws {
        try generate([view], outputPath: outputPath, dpi: dpi)
    }
    

    /**
     Generate from views.
     
     - parameter views:      Array of views.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(_ views: [UIView], outputPath: String, dpi: DPIType = .default) throws {
        try generate(PDFPage.pages(views), outputPath: outputPath, dpi: dpi)
    }
    
    /**
     Generate from image.
     
     - parameter image:      An image.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(_ image: UIImage, outputPath: String, dpi: DPIType = .default) throws {
        try generate([image], outputPath: outputPath, dpi: dpi)
    }
    
    /**
     Generate from images.
     
     - parameter images:     Array of images.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(_ images: [UIImage], outputPath: String, dpi: DPIType = .default) throws {
        try generate(PDFPage.pages(images), outputPath: outputPath, dpi: dpi)
    }

    /**
     Generate from image path.
     
     - parameter imagePath:  An image path.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(_ imagePath: String, outputPath: String, dpi: DPIType = .default) throws {
        try generate([imagePath], outputPath: outputPath, dpi: dpi)
    }
    
    /**
     Generate from image paths.
     
     - parameter imagePaths: Arrat of image paths.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(_ imagePaths: [String], outputPath: String, dpi: DPIType = .default) throws {
        try generate(PDFPage.pages(imagePaths), outputPath: outputPath, dpi: dpi)
    }
    
    
    /**
     Generate from page object.
     
     - parameter page: A `PDFPage`'s object.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(_ page: PDFPage, dpi: DPIType = .default) throws -> Data {
        return try generate([page], dpi: dpi)
    }

    /**
     Generate from page objects.
     
     - parameter pages: Array of `PDFPage`'s objects.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(_ pages: [PDFPage], dpi: DPIType = .default) throws -> Data {
        guard !pages.isEmpty else {
            throw PDFGenerateError.emptyPage
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
    public class func generate(_ view: UIView, dpi: DPIType = .default) throws -> Data {
        return try generate([view], dpi: dpi)
    }

    /**
     Generate from views.
     
     - parameter views: Array of views.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(_ views: [UIView], dpi: DPIType = .default) throws -> Data  {
        return try generate(PDFPage.pages(views), dpi: dpi)
    }
    
    /**
     Generate from image.
     
     - parameter image: An image.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(_ image: UIImage, dpi: DPIType = .default) throws -> Data {
        return try generate([image], dpi: dpi)
    }

    /**
     Generate from images.
     
     - parameter images: Array of images.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(_ images: [UIImage], dpi: DPIType = .default) throws -> Data {
        return try generate(PDFPage.pages(images), dpi: dpi)
    }
    
    /**
     Generate from image path.
     
     - parameter imagePath: An image path.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(_ imagePath: String, dpi: DPIType = .default) throws -> Data {
        return try generate([imagePath], dpi: dpi)
    }
    
    /**
     Generate from image paths.
     
     - parameter imagePaths: Arrat of image paths.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    @warn_unused_result
    public class func generate(_ imagePaths: [String], dpi: DPIType = .default) throws -> Data {
        return try generate(PDFPage.pages(imagePaths), dpi: dpi)
    }
}

// MARK: Private Extension

/// PDFGenerator private extensions (render processes)
private extension PDFGenerator {
    class func renderPage(_ page: PDFPage, dpi: DPIType) throws {
        let scaleFactor: CGFloat = dpi.value / DPIType.default.value
        /// Inner function
        func renderImage(_ imageConvertible: UIImageConvertible) throws {
            try imageConvertible.to_image().renderPDFPage(scaleFactor)
        }
        
        try autoreleasepool {
            switch page {
            case .whitePage(let size):
                let view = UIView(frame: CGRect(origin: .zero, size: size))
                view.backgroundColor = .white()
                try view.renderPDFPage(scaleFactor)
            case .view(let view):
                try view.renderPDFPage(scaleFactor)
            case .image(let image):
                try renderImage(image)
            case .imagePath(let ip):
                try renderImage(ip)
            case .binary(let data):
                try renderImage(data)
            case .imageRef(let cgImage):
                try renderImage(cgImage)
            }
        }
    }
    
    class func renderPages(_ pages: [PDFPage], dpi: DPIType) throws {
        try pages.forEach { try renderPage($0, dpi: dpi) }
    }
    
    class func outputToFile(_ outputPath: String, process: Process) rethrows {
        UIGraphicsBeginPDFContextToFile(outputPath, .zero, nil)
        defer {
            UIGraphicsEndPDFContext()
        }
        try process()
    }
    
    class func outputToData(_ process: Process) rethrows -> Data {
        let data = NSMutableData()
        UIGraphicsBeginPDFContextToData(data, .zero, nil)
        defer {
            UIGraphicsEndPDFContext()
        }
        try process()
        return data as Data
    }
}
