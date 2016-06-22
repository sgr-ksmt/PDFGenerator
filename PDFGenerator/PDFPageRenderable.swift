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
    func renderPDFPage(scaleFactor: CGFloat) throws
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
    func renderPDFPage(scaleFactor: CGFloat) throws {
        guard scaleFactor > 0.0 else {
            throw PDFGenerateError.InvalidScaleFactor
        }
        
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
                let renderFrame = CGRect(
                    origin: .zero,
                    size: CGSize(
                        width: size.width * scaleFactor,
                        height: size.height * scaleFactor
                    )
                )
                UIGraphicsBeginPDFPageWithInfo(renderFrame, nil)
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
                let renderFrame = CGRect(
                    origin: .zero,
                    size: CGSize(
                        width: size.width * scaleFactor,
                        height: size.height * scaleFactor
                    )
                )
                UIGraphicsBeginPDFPageWithInfo(renderFrame, nil)
                self.layer.renderInContext(context)
            }
        }
    }
    
    private func getPageSize() -> CGSize {
        switch self {
        case (let webView as UIWebView):
            return webView.scrollView.contentSize
        case (let webView as WKWebView):
            return webView.scrollView.contentSize
        case (let scrollView as UIScrollView):
            return scrollView.contentSize
        default:
            return self.frame.size
        }
    }
}

extension UIImage: PDFPageRenderable {
    func renderPDFPage(scaleFactor: CGFloat) throws {
        guard scaleFactor > 0.0 else {
            throw PDFGenerateError.InvalidScaleFactor
        }
        autoreleasepool {
            let bounds = CGRect(
                origin: .zero,
                size: CGSize(
                    width: size.width * scaleFactor,
                    height: size.height * scaleFactor
                )
            )
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
