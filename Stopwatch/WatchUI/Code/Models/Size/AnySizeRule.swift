//
//  AnySizeRule.swift
//  WatchUI
//
//  Created by alphacircle on 2/23/26.
//

import Foundation

/// 크기 규칙 타입 소거 래퍼
public struct AnySizeRule: SizeRule {
    let rule: SizeRule
    
    /// 기본 이니셜라이저
    ///
    /// - Parameter rule: 크기 규칙
    public init(rule: SizeRule) {
        self.rule = rule
    }
    
    public func transform(from original: CGFloat) -> CGFloat {
        rule.transform(from: original)
    }
}
