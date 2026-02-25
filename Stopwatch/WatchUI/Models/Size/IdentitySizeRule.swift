//
//  IdentitySizeRule.swift
//  WatchUI
//
//  Created by alphacircle on 2/23/26.
//

import Foundation

public struct IdentitySizeRule: SizeRule {
    public init() {}
    
    public func transform(from original: CGFloat) -> CGFloat {
        return original
    }
}
