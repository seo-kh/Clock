//
//  PropotionalSizeRule.swift
//  WatchUI
//
//  Created by alphacircle on 2/24/26.
//

import Foundation

struct PropotionalSizeRule: SizeRule {
    let ratio: CGFloat
    
    func transform(from original: CGFloat) -> CGFloat {
        return original * ratio
    }
}
