//
//  AnySizeRule.swift
//  WatchUI
//
//  Created by alphacircle on 2/23/26.
//

import Foundation

public struct AnySizeRule: SizeRule {
    let rule: SizeRule
    
    public init(rule: SizeRule) {
        self.rule = rule
    }
    
    public func transform(from original: CGFloat) -> CGFloat {
        rule.transform(from: original)
    }
}
