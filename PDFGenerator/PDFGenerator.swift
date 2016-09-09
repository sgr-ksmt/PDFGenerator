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
    fileprivate typealias Process = () throws -> Void
    
    /// Avoid creating instance.
    fileprivate init() {}
    
    /**
     Generate from page object.
     
     - parameter page:       A `PDFPage`'s object.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(_ page: PDFPage, outputPath: FilePathConvertible, dpi: DPIType = .default, password: PDFPassword = "") throws {
        try generate([page], outputPath: outputPath, dpi: dpi, password: password)
    }
    
    /**
     Generate from page objects.
     
     - parameter pages:      Array of `PDFPage`'s objects.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(_ pages: [PDFPage], outputPath: FilePathConvertible, dpi: DPIType = .default, password: PDFPassword = "") throws {
        guard !pages.isEmpty else {
            throw PDFGenerateError.emptyPage
        }
        guard !outputPath.path.isEmpty else {
            throw PDFGenerateError.emptyOutputPath
        }
        do {
            try outputToFile(outputPath.path, password: password) {
                try renderPages(pages, dpi: dpi)
            }
        } catch (let error) {
            _ = try? FileManager.default.removeItem(at: outputPath.url as URL)
            throw error
        }
    }
    
    /**
     Generate from view.
     
     - parameter view:       A view
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(_ view: UIView, outputPath: FilePathConvertible, dpi: DPIType = .default, password: PDFPassword = "") throws {
        try generate([view], outputPath: outputPath, dpi: dpi, password: password)
    }
    

    /**
     Generate from views.
     
     - parameter views:      Array of views.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(_ views: [UIView], outputPath: FilePathConvertible, dpi: DPIType = .default, password: PDFPassword = "") throws {
        try generate(PDFPage.pages(views), outputPath: outputPath, dpi: dpi, password: password)
    }
    
    /**
     Generate from image.
     
     - parameter image:      An image.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(_ image: UIImage, outputPath: FilePathConvertible, dpi: DPIType = .default, password: PDFPassword = "") throws {
        try generate([image], outputPath: outputPath, dpi: dpi, password: password)
    }
    
    /**
     Generate from images.
     
     - parameter images:     Array of images.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(_ images: [UIImage], outputPath: FilePathConvertible, dpi: DPIType = .default, password: PDFPassword = "") throws {
        try generate(PDFPage.pages(images), outputPath: outputPath, dpi: dpi, password: password)
    }

    /**
     Generate from image path.
     
     - parameter imagePath:  An image path.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(_ imagePath: String, outputPath: FilePathConvertible, dpi: DPIType = .default, password: PDFPassword = "") throws {
        try generate([imagePath], outputPath: outputPath, dpi: dpi, password: password)
    }
    
    /**
     Generate from image paths.
     
     - parameter imagePaths: Arrat of image paths.
     - parameter outputPath: An outputPath to save PDF.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     */
    public class func generate(_ imagePaths: [String], outputPath: FilePathConvertible, dpi: DPIType = .default, password: PDFPassword = "") throws {
        try generate(PDFPage.pages(imagePaths), outputPath: outputPath, dpi: dpi, password: password)
    }
    
    
    /**
     Generate from page object.
     
     - parameter page: A `PDFPage`'s object.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    
    public class func generate(_ page: PDFPage, dpi: DPIType = .default, password: PDFPassword = "") throws -> Data {
        return try generate([page], dpi: dpi, password: password)
    }

    /**
     Generate from page objects.
     
     - parameter pages: Array of `PDFPage`'s objects.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    
    public class func generate(_ pages: [PDFPage], dpi: DPIType = .default, password: PDFPassword = "") throws -> Data {
        guard !pages.isEmpty else {
            throw PDFGenerateError.emptyPage
        }
        return try outputToData(password: password) { try renderPages(pages, dpi: dpi) }
    }

    /**
     Generate from view.
     
     - parameter view: A view
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    
    public class func generate(_ view: UIView, dpi: DPIType = .default, password: PDFPassword = "") throws -> Data {
        return try generate([view], dpi: dpi, password: password)
    }

    /**
     Generate from views.
     
     - parameter views: Array of views.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    
    public class func generate(_ views: [UIView], dpi: DPIType = .default, password: PDFPassword = "") throws -> Data  {
        return try generate(PDFPage.pages(views), dpi: dpi, password: password)
    }
    
    /**
     Generate from image.
     
     - parameter image: An image.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    
    public class func generate(_ image: UIImage, dpi: DPIType = .default, password: PDFPassword = "") throws -> Data {
        return try generate([image], dpi: dpi, password: password)
    }

    /**
     Generate from images.
     
     - parameter images: Array of images.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    
    public class func generate(_ images: [UIImage], dpi: DPIType = .default, password: PDFPassword = "") throws -> Data {
        return try generate(PDFPage.pages(images), dpi: dpi, password: password)
    }
    
    /**
     Generate from image path.
     
     - parameter imagePath: An image path.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    
    public class func generate(_ imagePath: String, dpi: DPIType = .default, password: PDFPassword = "") throws -> Data {
        return try generate([imagePath], dpi: dpi, password: password)
    }
    
    /**
     Generate from image paths.
     
     - parameter imagePaths: Arrat of image paths.
     
     - throws: A `PDFGenerateError` thrown if some error occurred.
     
     - returns: PDF's binary data (NSData)
     */
    
    public class func generate(_ imagePaths: [String], dpi: DPIType = .default, password: PDFPassword = "") throws -> Data {
        return try generate(PDFPage.pages(imagePaths), dpi: dpi, password: password)
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
                view.backgroundColor = .white
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
    
    class func outputToFile(_ outputPath: String, password: PDFPassword, process: Process) rethrows {
        try { try password.verify() }()
        UIGraphicsBeginPDFContextToFile(outputPath, .zero, password.toDocumentInfo())
        defer { UIGraphicsEndPDFContext() }
        try process()
    }
    
    class func outputToData(password: PDFPassword, process: Process) rethrows -> Data {
        try { try password.verify() }()
        let data = NSMutableData()
        UIGraphicsBeginPDFContextToData(data, .zero, password.toDocumentInfo())
        defer { UIGraphicsEndPDFContext() }
        try process()
        return data as Data
    }
}
