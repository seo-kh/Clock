//
//  EqualSizeRule.swift
//  WatchUI
//
//  Created by alphacircle on 2/23/26.
//

import Foundation

struct EqualSizeRule: SizeRule {
    let total: CGFloat
    
    func transform(from original: CGFloat) -> CGFloat {
        let radius: CGFloat = original / 2.0
        let unitLength = 2.0 * CGFloat.pi * radius / total
        return unitLength
    }
}

