//
//  PropotionalSizeRule.swift
//  WatchUI
//
//  Created by alphacircle on 2/24/26.
//

import Foundation

public struct PropotionalSizeRule: SizeRule {
    let ratio: CGFloat
    
    public init(ratio: CGFloat) {
        self.ratio = ratio
    }
    
    public func transform(from original: CGFloat) -> CGFloat {
        return original * ratio
    }
}
