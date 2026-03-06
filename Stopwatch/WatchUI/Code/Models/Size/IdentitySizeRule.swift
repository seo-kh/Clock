//
//  IdentitySizeRule.swift
//  WatchUI
//
//  Created by alphacircle on 2/23/26.
//

import Foundation

/// 동일 크기 규칙
///
/// 부모 크기를 그대로 사용
public struct IdentitySizeRule: SizeRule {
    
    public init() {}
    
    public func transform(from original: CGFloat) -> CGFloat {
        return original
    }
}
