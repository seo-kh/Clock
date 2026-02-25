//
//  EqualSizeRule.swift
//  WatchUI
//
//  Created by alphacircle on 2/23/26.
//

import Foundation

public struct EqualSizeRule: SizeRule {
    let total: CGFloat
    
    public init(total: CGFloat) {
        self.total = total
    }
    
    public func transform(from original: CGFloat) -> CGFloat {
        let unitLength = 2.0 * CGFloat.pi * original / total
        return unitLength
    }
}

