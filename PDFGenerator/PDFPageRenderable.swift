//
//  PDFPageRenderable.swift
//  PDFGenerator
//
//  Created by Suguru Kishimoto on 2016/02/10.
//
//

import Foundation
import UIKit


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
    private func getPageSize() -> CGSize {
        if let scrollView = self as? UIScrollView {
            return scrollView.contentSize
        } else {
            return frame.size
        }
    }
    
    func renderPDFPage() throws {
        let size = getPageSize()
        guard size.width > 0 && size.height > 0 else {
            throw PDFGenerateError.ZeroSizeView(self)
        }
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        autoreleasepool {
            if let scrollView = self as? UIScrollView {
                let tmp = scrollView.tempInfo
                scrollView.transformForRender()
                UIGraphicsBeginPDFPageWithInfo(scrollView.frame, nil)
                scrollView.layer.renderInContext(context)
                scrollView.restore(tmp)
            } else {
                UIGraphicsBeginPDFPageWithInfo(bounds, nil)
                layer.renderInContext(context)
            }
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