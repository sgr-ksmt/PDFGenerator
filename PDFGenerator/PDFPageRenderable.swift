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

extension PDFPageRenderable {
    func renderPDFPage() throws {}
}

private extension UIScrollView {
    typealias TempInfo = (frame: CGRect, offset: CGPoint, inset: UIEdgeInsets)
    
    var tempInfo: TempInfo {
        return (self.frame,self.contentOffset,self.contentInset)
    }
    
    func resetInfoForRender() {
        self.contentOffset = CGPointZero
        self.contentInset = UIEdgeInsetsZero
        self.frame = CGRect(origin: CGPointZero, size: self.contentSize)
    }
    
    func restoreFromInfo(info: TempInfo) {
        self.frame = info.frame
        self.contentOffset = info.offset
        self.contentInset = info.inset
    }
    
}

extension UIView: PDFPageRenderable {
    private func getPageSize() -> CGSize {
        if let scrollView = self as? UIScrollView {
            return scrollView.contentSize
        } else {
            return self.frame.size
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
                scrollView.resetInfoForRender()
                UIGraphicsBeginPDFPageWithInfo(scrollView.frame, nil)
                scrollView.layer.renderInContext(context)
                scrollView.restoreFromInfo(tmp)
            } else {
                UIGraphicsBeginPDFPageWithInfo(self.bounds, nil)
                self.layer.renderInContext(context)
            }
        }
    }
}

extension UIImage: PDFPageRenderable {
    func renderPDFPage() throws {
        autoreleasepool {
            let bounds = CGRect(origin: CGPointZero, size: self.size)
            UIGraphicsBeginPDFPageWithInfo(bounds, nil)
            self.drawInRect(bounds)
        }
    }
}

protocol UIImageConvertible {
    func to_image() throws -> UIImage
}

extension String: UIImageConvertible {
    func to_image() throws -> UIImage{
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