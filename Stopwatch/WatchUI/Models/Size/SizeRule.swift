//
//  SizeRule.swift
//  WatchUI
//
//  Created by alphacircle on 2/23/26.
//

import Foundation

public protocol SizeRule {
    func transform(from original: CGFloat) -> CGFloat
}

public extension SizeRule where Self == FixedSizeRule {
    static func fixed(_ size: CGFloat) -> some SizeRule {
        FixedSizeRule(size: size)
    }
}
    
public extension SizeRule where Self == EqualSizeRule {
    static func equal(parts: CGFloat, span: CGFloat = 1) -> some SizeRule {
        EqualSizeRule(total: parts * span)
    }
}
    
public extension SizeRule where Self == IdentitySizeRule {
    static var identity: some SizeRule {
        IdentitySizeRule()
    }
}
    
public extension SizeRule where Self == PropotionalSizeRule {
    static func propotional(_ ratio: CGFloat) -> some SizeRule {
        PropotionalSizeRule(ratio: ratio)
    }
}
