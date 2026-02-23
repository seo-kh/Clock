//
//  FixedSizeRule.swift
//  WatchUI
//
//  Created by alphacircle on 2/23/26.
//

import Foundation

struct FixedSizeRule: SizeRule {
    let size: CGFloat
    
    func transform(from original: CGFloat) -> CGFloat {
        return size
    }
}
