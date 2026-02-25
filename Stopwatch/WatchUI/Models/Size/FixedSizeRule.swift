//
//  FixedSizeRule.swift
//  WatchUI
//
//  Created by alphacircle on 2/23/26.
//

import Foundation

public struct FixedSizeRule: SizeRule {
    let size: CGFloat
    
    public init(size: CGFloat) {
        self.size = size
    }
    
    public func transform(from original: CGFloat) -> CGFloat {
        return size
    }
}
