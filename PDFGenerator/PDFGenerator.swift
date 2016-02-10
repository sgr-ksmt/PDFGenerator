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
    case WhitePage(CGSize)
    case View(UIView)
    case Image(UIImage)
    case ImagePath(String)
    
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

public enum PDFGenerateError: ErrorType {
    case EmptyView(UIView)
    case EmptyImage(UIImage)
    case ImageLoadFailed(String)
    case EmptyOutputPath
}

/// PDFGenerator
public final class PDFGenerator {
    private typealias Process = () throws -> Void
    
    private init() {}
    
    public class func generate(page: PDFPage, outputPath: String) throws {
        try generate([page], outputPath: outputPath)
    }
    
    public class func generate(pages: [PDFPage], outputPath: String) throws {
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
    
    public class func generate(view: UIView, outputPath: String) throws {
        try generate([view],outputPath: outputPath)
    }
    
    public class func generate(views: [UIView], outputPath: String) throws {
        try generate(PDFPage.pages(views), outputPath: outputPath)
    }
    
    public class func generate(image: UIImage, outputPath: String) throws {
        try generate([image], outputPath: outputPath)
    }
    
    public class func generate(images: [UIImage], outputPath: String) throws {
        try generate(PDFPage.pages(images), outputPath: outputPath)
    }

    public class func generate(imagePath: String, outputPath: String) throws {
        try generate([imagePath], outputPath: outputPath)
    }
    
    public class func generate(imagePaths: [String], outputPath: String) throws {
        try generate(PDFPage.pages(imagePaths), outputPath: outputPath)
    }
    
    public class func generate(page: PDFPage) throws -> NSData {
        return try generate([page])
    }

    public class func generate(pages: [PDFPage]) throws -> NSData {
        return try outputToData { try renderPages(pages) }
    }

    public class func generate(view: UIView) throws -> NSData {
        return try generate([view])
    }

    public class func generate(views: [UIView]) throws -> NSData  {
        return try generate(PDFPage.pages(views))
    }
    
    public class func generate(image: UIImage) throws -> NSData {
        return try generate([image])
    }

    public class func generate(images: [UIImage]) throws -> NSData {
        return try generate(PDFPage.pages(images))
    }
    
    
    public class func generate(imagePath: String) throws -> NSData {
        return try generate([imagePath])
    }
    
    public class func generate(imagePaths: [String]) throws -> NSData {
        return try generate(PDFPage.pages(imagePaths))
    }
}

private extension PDFGenerator {
    class func renderPage(page: PDFPage) throws {
        switch page {
        case .WhitePage(let size):
            try autoreleasepoolTry {
                let view = UIView(frame: CGRect(origin: CGPointZero, size: size))
                view.backgroundColor = UIColor.whiteColor()
                try view.renderPDFPage()
            }
        case .View(let view):
            try view.renderPDFPage()
        case .Image(let image):
            try image.renderPDFPage()
        case .ImagePath(let ip):
            try autoreleasepoolTry {
                try ip.to_image().renderPDFPage()
            }
        }
    }
    
    class func renderPages(pages: [PDFPage]) throws {
        try pages.forEach {
            try renderPage($0)
        }
    }
    
    class func outputToFile(outputPath: String, process: Process) rethrows {
        UIGraphicsBeginPDFContextToFile(outputPath, CGRectZero, nil)
        defer {
            UIGraphicsEndPDFContext()
        }
        try process()
    }
    
    class func outputToData(process: Process) rethrows -> NSData {
        let data = NSMutableData()
        UIGraphicsBeginPDFContextToData(data, CGRectZero, nil)
        defer {
            UIGraphicsEndPDFContext()
        }
        try process()
        return data
    }
}