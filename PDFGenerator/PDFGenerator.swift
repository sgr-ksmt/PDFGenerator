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
    
    private typealias Process = () -> Void
    private init() {}
    
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
        outputToFile(outputPath) {
            renderViews(views)
        }
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
        return outputToData {
            renderViews(views)
        }
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
        outputToFile(outputPath) {
            renderImages(images)
        }
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
        return outputToData {
            renderImages(images)
        }
    }
    
    /**
     Generate PDF file from single image path
     
     - parameter imagePath: An image path.
     - parameter outputPath: A Path to write PDF file.
     */
    public class func generate(imagePath: String, outputPath: String) {
        generate([imagePath], outputPath: outputPath)
    }

    /**
     Generate PDF file from image paths
     
     - parameter imagePaths: Array of image path.
     - parameter outputPath: A Path to write PDF file.
     */
    public class func generate(imagePaths: [String], outputPath: String) {
        outputToFile(outputPath) {
            renderImagesWithImagePaths(imagePaths)
        }
    }
    
    /**
     Generate PDF file as row data(`NSData`) from single image path.
     
     - parameter imagePath: An image path.
     
     - returns: A data of PDF file's.(`NSData`)
     */
    public class func generate(imagePath: String) -> NSData {
        return generate([imagePath])
    }
    
    /**
     Generate PDF file as row data(`NSData`) from image paths
     
     - parameter image: Array of image path.
     
     - returns: A data of PDF file's.(`NSData`)
     */
    public class func generate(imagePaths: [String]) -> NSData {
        return outputToData {
            renderImagesWithImagePaths(imagePaths)
        }
    }
    
    
    private class func outputToFile(outputPath: String, process: Process) {
        UIGraphicsBeginPDFContextToFile(outputPath, CGRectZero, nil)
        process()
        UIGraphicsEndPDFContext()
    }
    
    private class func outputToData(process: Process) -> NSData {
        let data = NSMutableData()
        UIGraphicsBeginPDFContextToData(data, CGRectZero, nil)
        process()
        UIGraphicsEndPDFContext()
        return data
    }
    
    private class func renderViews(views: [UIView]) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        views.forEach {
            if let scrollView = $0 as? UIScrollView {
                let tmp = (offset: scrollView.contentOffset, frame: scrollView.frame)
                scrollView.contentOffset = CGPointZero
                scrollView.frame = CGRect(origin: CGPointZero, size: scrollView.contentSize)
                UIGraphicsBeginPDFPageWithInfo(scrollView.frame, nil)
                $0.layer.renderInContext(context)
                scrollView.frame = tmp.frame
                scrollView.contentOffset = tmp.offset
            } else {
                UIGraphicsBeginPDFPageWithInfo($0.bounds, nil)
                $0.layer.renderInContext(context)
            }
        }
    }
    
    private class func renderImage(image: UIImage) {
        let bounds = CGRect(origin: CGPointZero, size: image.size)
        UIGraphicsBeginPDFPageWithInfo(bounds, nil)
        image.drawInRect(bounds)
    }

    private class func renderImages(images: [UIImage]) {
        images.forEach {
            renderImage($0)
        }
    }
    
    private class func renderImagesWithImagePaths(imagePaths: [String]) {
        imagePaths.forEach {
            let imagePath = $0
            autoreleasepool {
                guard let image = UIImage(contentsOfFile: imagePath) else {
                    return
                }
                renderImage(image)
            }
        }
    }
    
}
