//
//  TextMark.swift
//  WatchUI
//
//  Created by alphacircle on 2/6/26.
//

import SwiftUI

/// Text를 그려내는 마크 콘텐츠
///
/// SwiftUI Text 렌더링
///
/// ```swift
/// Watchface {
///     Layer {
///         TextMark(anchor: .center) {
///             Text("Text Mark")
///                 .font(.largeTitle)
///                 .bold()
///         }
///     }
/// }
/// ```
///
/// 위 코드는 TextMark 예시를 나타냅니다.
///
/// ![An image of text watch content](text.png)
public struct TextMark: WatchContent {
    private let text: Text
    private let anchor: UnitPoint
    
    /// 기본 이니셜라이저
    /// - Parameters:
    ///   - anchor: 드로잉 기준점
    ///   - content: Text 콘텐츠 클로저
    ///
    /// ```swift
    /// TextMark(anchor: .center) {
    ///     Text("12")
    ///         .font(.system(size: 14, weight: .bold))
    ///         .foregroundStyle(.white)
    /// }
    /// ```
    public init(anchor: UnitPoint = .center, content: () -> Text) {
        self.text = content()
        self.anchor = anchor
    }
    
    /// 편의 이니셜라이저
    /// - Parameters:
    ///   - text: text 문자열
    ///   - anchor: 드로잉 기준점
    ///
    /// ```swift
    /// TextMark(text: "12", anchor: .leading)
    /// ```
    public init(text: String, anchor: UnitPoint = .center) {
        self.init(anchor: anchor, content: { Text(text) })
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        context.draw(self.text, at: rect.origin, anchor: anchor)
    }
}

#Preview("test: one mark render") {
    Watchface {
        Layer {
            TextMark(anchor: .center) {
                Text("Text Mark")
                    .font(.largeTitle)
                    .bold()
            }
        }
    }
}
