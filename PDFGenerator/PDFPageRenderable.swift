//
//  PDFPageRenderable.swift
//  PDFGenerator
//
//  Created by Suguru Kishimoto on 2016/02/10.
//
//

import Foundation
import UIKit
import WebKit


protocol PDFPageRenderable {
    func renderPDFPage() throws
}

private extension UIScrollView {
    typealias TempInfo = (frame: CGRect, offset: CGPoint, inset: UIEdgeInsets)
    
    var tempInfo: TempInfo {
        return (frame, contentOffset, contentInset)
    }
    
    func transformForRender() {
        contentOffset = .zero
        contentInset = UIEdgeInsetsZero
        frame = CGRect(origin: .zero, size: contentSize)
    }
    
    func restore(info: TempInfo) {
        frame = info.frame
        contentOffset = info.offset
        contentInset = info.inset
    }
    
}

extension UIView: PDFPageRenderable {
    func renderPDFPage() throws {
        let size = getPageSize()
        guard size.width > 0 && size.height > 0 else {
            throw PDFGenerateError.ZeroSizeView(self)
        }
        guard let context = UIGraphicsGetCurrentContext() else {
            throw PDFGenerateError.InvalidContext
        }
        
        func renderScrollView(scrollView: UIScrollView) {
            autoreleasepool {
                let tmp = scrollView.tempInfo
                scrollView.transformForRender()
                UIGraphicsBeginPDFPageWithInfo(scrollView.frame, nil)
                scrollView.layer.renderInContext(context)
                scrollView.restore(tmp)
            }
        }
        
        if let webView = self as? UIWebView {
            renderScrollView(webView.scrollView)
        } else if let webView = self as? WKWebView {
            renderScrollView(webView.scrollView)
        } else if let scrollView = self as? UIScrollView {
            renderScrollView(scrollView)
        } else {
            autoreleasepool {
                UIGraphicsBeginPDFPageWithInfo(bounds, nil)
                layer.renderInContext(context)
            }
        }
    }
    
    private func getPageSize() -> CGSize {
        if let scrollView = self as? UIScrollView {
            return scrollView.contentSize
        } else {
            return frame.size
        }
    }
}

extension UIImage: PDFPageRenderable {
    func renderPDFPage() throws {
        autoreleasepool {
            let bounds = CGRect(origin: .zero, size: size)
            UIGraphicsBeginPDFPageWithInfo(bounds, nil)
            drawInRect(bounds)
        }
    }
}

protocol UIImageConvertible {
    func to_image() throws -> UIImage
}

extension UIImage: UIImageConvertible {
    func to_image() throws -> UIImage {
        return self
    }
}

extension String: UIImageConvertible {
    func to_image() throws -> UIImage {
        guard let image = UIImage(contentsOfFile: self) else{
            throw PDFGenerateError.ImageLoadFailed(self)
        }
        return image
    }
}

extension NSData: UIImageConvertible {
    func to_image() throws -> UIImage {
        guard let image = UIImage(data: self) else {
            throw PDFGenerateError.ImageLoadFailed(self)
        }
        return image
    }
}

extension CGImage: UIImageConvertible {
    func to_image() throws -> UIImage {
        return UIImage(CGImage: self)
    }
}