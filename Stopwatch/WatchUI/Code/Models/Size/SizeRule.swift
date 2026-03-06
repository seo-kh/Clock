//
//  SizeRule.swift
//  WatchUI
//
//  Created by alphacircle on 2/23/26.
//

import Foundation

/// 크기 계산 규칙 프로토콜
public protocol SizeRule {
    /// 크기 변환
    /// - Parameter original: 기준 크기
    /// - Returns: 변환된 크기
    func transform(from original: CGFloat) -> CGFloat
}

public extension SizeRule where Self == FixedSizeRule {
    /// 고정값 규칙
    /// - Parameter size: 고정 크기
    /// - Returns: 사이즈 룰
    static func fixed(_ size: CGFloat) -> some SizeRule {
        FixedSizeRule(size: size)
    }
}
    
public extension SizeRule where Self == EqualSizeRule {
    /// 원주 균등 호 길이 규칙
    /// 
    /// - Parameter total: 균등 분배 개수
    /// - Returns: 사이즈 룰
    ///
    /// 원주를 total로 균등 분배한 호 길이를 계산합니다.
    static func equal(total: CGFloat) -> some SizeRule {
        EqualSizeRule(total: total)
    }
}
    
public extension SizeRule where Self == IdentitySizeRule {
    /// 동일값 규칙
    /// 
    /// 기준 크기와 동일함
    static var identity: some SizeRule {
        IdentitySizeRule()
    }
}
    
public extension SizeRule where Self == PropotionalSizeRule {
    /// 비율값 규칙
    ///
    /// - Parameter ratio: 크기 비율
    /// - Returns: 사이즈 룰
    ///
    /// 기준 크기 x ratio 크기를 반환
    static func propotional(_ ratio: CGFloat) -> some SizeRule {
        PropotionalSizeRule(ratio: ratio)
    }
}
