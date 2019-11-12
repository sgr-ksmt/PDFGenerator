//
//  PDFPagedScrollViewConfiguration.swift
//  ActionSheetPicker-3.0
//
//  Created by Philip Messlehner on 03.08.18.
//

import Foundation

public struct PDFPagedScrollViewConfiguration {
    public let overlapPercentage: CGFloat
    public let ratio: PageRatio

    public init(overlapPercentage: CGFloat, ratio: PageRatio) {
        self.overlapPercentage = overlapPercentage
        self.ratio = ratio
    }

    public enum PageRatio {
        case dinA3, dinA4, dinA5
        case ansiA, ansiB, ansiC
        case invoice, executive, legal, letter
        case custom(CGFloat)

        public var rawValue: CGFloat {
            switch self {
            case .dinA3: return 297.0 / 420.0
            case .dinA4: return 210.0 / 297.0
            case .dinA5: return 148.0 / 210.0
            case .ansiA: return 216.0 / 279.0
            case .ansiB: return 279.0 / 432.0
            case .ansiC: return 432.0 / 559.0
            case .invoice: return 140.0 / 216.0
            case .executive: return 184.0 / 267.0
            case .legal: return 216.0 / 356.0
            case .letter: return PageRatio.ansiA.rawValue
            case .custom(let ratio): return ratio
            }
        }
    }
}
