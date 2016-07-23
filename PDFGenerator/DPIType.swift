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
    case Default
    case DPI_300
    case Custom(CGFloat)
    
    public var value: CGFloat {
        switch self {
        case .Default:
            return self.dynamicType.defaultDpi
        case .DPI_300:
            return 300.0
        case .Custom(let value) where value > 1.0:
            return value
        default:
            return DPIType.Default.value
        }
    }
}
