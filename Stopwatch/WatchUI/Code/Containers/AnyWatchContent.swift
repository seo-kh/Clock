//
//  AnyWatchContent.swift
//  WatchUI
//
//  Created by alphacircle on 2/19/26.
//

import SwiftUI

/// 타입 소거 래퍼 콘텐츠
///
/// ``WatchContent``의 타입 소거 (type erasure) 래퍼. 구체적인 타입을 숨깁니다.
public struct AnyWatchContent: WatchContent {
    let content: any WatchContent
    
    /// 기본 이니셜라이저
    /// - Parameter content: 콘텐츠
    public init(content: any WatchContent) {
        self.content = content
    }
    
    /// 편의 이니셜라이저
    /// - Parameter content: 콘텐츠 클로저
    public init<C: WatchContent>(content: @escaping () -> C) {
        self.content = content()
    }

    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        content
            .render(&context, rect: rect)
    }
}
