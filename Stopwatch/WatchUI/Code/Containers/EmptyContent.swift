//
//  EmptyContent.swift
//  WatchUI
//
//  Created by 테스트 on 2/28/26.
//

import Foundation
import SwiftUI

/// 빈 콘텐츠
///
/// 아무것도 그리지 않는 빈 콘텐츠. \
/// ``WatchContentBuilder/buildBlock()``이 빈 블록일 때 반환합니다.
public struct EmptyContent: WatchContent {
    /// 기본 이니셜라이저
    public init() {}
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        
    }
}
