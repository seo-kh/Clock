//
//  ImageMark.swift
//  WatchUI
//
//  Created by alphacircle on 2/9/26.
//

import SwiftUI

/// Image를 그려내는 마크 콘텐츠
///
/// SwiftUI Image 렌더링
///
/// ```swift
/// Watchface {
///     Layer(anchor: .center) {
///         ImageMark {
///             Image(systemName: "clock")
///         }
///         .frame(width: 50, height: 50)
///
///         ImageMark(anchor: .topLeading) {
///             Image(systemName: "clock")
///         }
///         .frame(width: 50, height: 50)
///     }
/// }
/// ```
///
/// 위 코드는 ImageMark 사용 예시입니다.
///
/// ![An image of image watch content](image.png)
public struct ImageMark: WatchContent {
    let image: Image
    let anchor: UnitPoint
    
    /// 기본 이니셜라이저
    /// - Parameters:
    ///   - anchor: 드로인 기준점
    ///   - content: 이미지 콘텐츠 클로저
    ///
    /// ```swift
    /// ImageMark {
    ///     Image(systemName: "clock")
    /// }
    /// .frame(width: 50, height: 50)
    /// ```
    public init(anchor: UnitPoint = .center, content: () -> Image) {
        self.image = content()
        self.anchor = anchor
    }
    
    /// 편의 이니셜라이저
    /// - Parameters:
    ///   - systemName: SF Symbol 이름
    ///   - anchor: 드로인 기준점
    ///
    /// ```swift
    /// ImageMark(systemName: "clock")
    ///     .frame(width: 40, height: 40)
    /// ```
    public init(systemName: String, anchor: UnitPoint = .center) {
        self.init(anchor: anchor, content: { Image(systemName: systemName) })
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        context.draw(image, at: rect.origin, anchor: anchor)
    }
}

#Preview {
    Watchface {
        Layer(anchor: .center) {
            ImageMark {
                Image(systemName: "clock")
            }
            .frame(width: 50, height: 50)

            ImageMark(anchor: .topLeading) {
                Image(systemName: "clock")
            }
            .frame(width: 50, height: 50)
        }
    }
}
