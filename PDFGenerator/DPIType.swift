//
//  DPIType.swift
//  PDFGenerator
//
//  Created by Suguru Kishimoto on 2016/06/21.
//
//

import Foundation
import UIKit

public enum DPIType {
    private static let defaultDpi: CGFloat = 72.0
    case `default`
    case dpi_300
    case custom(CGFloat)
    
    public var value: CGFloat {
        switch self {
        case .default:
            return self.dynamicType.defaultDpi
        case .dpi_300:
            return 300.0
        case .custom(let value):
            return value
        }
    }
}
