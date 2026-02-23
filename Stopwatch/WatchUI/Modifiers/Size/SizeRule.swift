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

public extension SizeRule where Self == AnySizeRule {
    static func fixed(_ size: CGFloat) -> some SizeRule {
        AnySizeRule(rule:FixedSizeRule(size: size))
    }
    
    static func equal(_ parts: CGFloat) -> some SizeRule {
        AnySizeRule(rule: EqualSizeRule(parts: parts))
    }
    
    static var identity: some SizeRule {
        AnySizeRule(rule: IdentitySizeRule())
    }
}
