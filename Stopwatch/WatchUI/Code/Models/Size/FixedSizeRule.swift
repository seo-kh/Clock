//
//  FixedSizeRule.swift
//  WatchUI
//
//  Created by alphacircle on 2/23/26.
//

import Foundation

/// 고정 크기 규칙
///
/// 픽셀 단위 고정 크기 적용
public struct FixedSizeRule: SizeRule {
    let size: CGFloat
    
    /// 기본 이니셜라이저
    ///
    /// - Parameter size: 고정 크기
    public init(size: CGFloat) {
        self.size = size
    }
    
    public func transform(from original: CGFloat) -> CGFloat {
        return size
    }
}
