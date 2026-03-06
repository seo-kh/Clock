//
//  PropotionalSizeRule.swift
//  WatchUI
//
//  Created by alphacircle on 2/24/26.
//

import Foundation

/// 비율 크기 규칙
///
/// 일정 비율로 크기를 결정
public struct PropotionalSizeRule: SizeRule {
    let ratio: CGFloat
    
    /// 기본 이니셜라이저
    ///
    /// - Parameter ratio: 크기 비율
    public init(ratio: CGFloat) {
        self.ratio = ratio
    }
    
    public func transform(from original: CGFloat) -> CGFloat {
        return original * ratio
    }
}
