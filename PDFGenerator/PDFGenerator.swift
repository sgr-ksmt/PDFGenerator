//
//  PDFGenerator.swift
//  PDFGenerator
//
//  Created by Suguru Kishimoto on 2016/02/04.
//
//

import Foundation
import UIKit

public final class PDFGenerator {
    
    private typealias Process = () -> Void
    private init() {}
    
    public class func generate(views: [UIView], outputPath: String) {
        outputToFile(outputPath) {
            renderViews(views)
        }
    }
    
    public class func generate(views: [UIView]) -> NSData {
        return outputToData {
            renderViews(views)
        }
    }
    
    public class func generate(images: [UIImage], outputPath: String) {
        outputToFile(outputPath) {
            renderImages(images)
        }
    }

    public class func generate(images: [UIImage]) -> NSData {
        return outputToData {
            renderImages(images)
        }
    }
    
    public class func generate(imagePaths: [String], outputPath: String) {
        outputToFile(outputPath) {
            renderImagesWithImagePaths(imagePaths)
        }
    }
    
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
                let tmpInfo = (offset: scrollView.contentOffset, frame: scrollView.frame)
                scrollView.contentOffset = CGPointZero
                scrollView.frame = CGRect(origin: CGPointZero, size: scrollView.contentSize)
                UIGraphicsBeginPDFPageWithInfo(scrollView.frame, nil)
                $0.layer.renderInContext(context)
                scrollView.frame = tmpInfo.frame
                scrollView.contentOffset = tmpInfo.offset
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
