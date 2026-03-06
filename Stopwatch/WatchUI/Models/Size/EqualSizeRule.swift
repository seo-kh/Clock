//
//  EqualSizeRule.swift
//  WatchUI
//
//  Created by alphacircle on 2/23/26.
//

import Foundation

/// 원주 균등 호 크기 규칙
///
/// 원주에 균등 배치할 때 동일한 크기 계산
public struct EqualSizeRule: SizeRule {
    let total: CGFloat
    
    /// 기본 이니셜라이저
    /// 
    /// - Parameter total: 균등 분배 개수
    public init(total: CGFloat) {
        self.total = total
    }
    
    public func transform(from original: CGFloat) -> CGFloat {
        let unitLength = 2.0 * CGFloat.pi * original / total
        return unitLength
    }
}

