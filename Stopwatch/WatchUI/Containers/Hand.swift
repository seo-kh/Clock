//
//  Hand.swift
//  WatchUI
//
//  Created by alphacircle on 2/23/26.
//

import Foundation
import SwiftUI

/// 시계 바늘
///
/// 시계 바늘을 위한 컨테이너.
/// ``Size``를 사용해 바늘의 크기 영역을 정의하고, 자식 콘텐츠에 계산된 `CGRect`를 전달합니다.
///
/// ```swift
/// Watchface {
///     Layer(anchor: .center) {
///         TextMark(anchor: .bottom) {
///             Text("Hand")
///                 .font(.body)
///                 .foregroundStyle(.orange)
///         }
///         .offset(y: -10)
///
///         Hand(size: Size(width: .equal(total: 180))) {
///             ShapeMark(Rectangle(), anchor: .top)
///                 .style(with: .color(.orange))
///                 .coordinateRotation(angle: .degrees(120))
///         }
///         .frame(width: 138)
///     }
///
///     Layer(anchor: .center) {
///         Scale(0..<60, period: 3) { tick in
///             ShapeMark(Rectangle(), anchor: .top)
///                 .style(with: .color(.gray))
///                 .aspectRatio(1.0 / 3.0)
///         }
///         .frame(width: 138)
///     }
/// }
/// ```
///
/// 위의 예제는 기본적인 Hand를 표현하는 방법을 나타냈습니다.
///
/// ![An image of hand watch content](hand.png)
public struct Hand<Content: WatchContent>: WatchContent {
    let size: Size
    let content: () -> Content
    
    /// 기본 이니셜라이저
    /// - Parameters:
    ///   - size: 바늘 영역의 크기 규칙
    ///   - content: 바늘 콘텐츠
    ///   
    /// ```swift
    /// Hand(size: .init(width: .equal(total: 180))) {
    ///     ShapeMark(Rectangle(), anchor: .top)
    ///         .style(with: .color(.orange))
    ///         .coordinateRotation(angle: currentAngle)
    /// }
    /// ```
    public init(size: Size, content: @escaping () -> Content) {
        self.size = size
        self.content = content
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        let length = min(rect.width, rect.height)
        let radius = length / 2.0
        let newRect = size.makeCGRect(length: radius)
        
        content()
            .render(&context, rect: newRect)
    }
}

#Preview {
    Watchface {
        Layer(anchor: .center) {
            TextMark(anchor: .bottom) {
                Text("Hand")
                    .font(.body)
                    .foregroundStyle(.orange)
            }
            .offset(y: -10)
            
            Hand(size: Size(width: .equal(total: 180))) {
                ShapeMark(Rectangle(), anchor: .top)
                    .style(with: .color(.orange))
                    .coordinateRotation(angle: .degrees(120))
            }
            .frame(width: 138)
        }
        
        Layer(anchor: .center) {
            Scale(0..<60, period: 3) { tick in
                ShapeMark(Rectangle(), anchor: .top)
                    .style(with: .color(.gray))
                    .aspectRatio(1.0 / 3.0)
            }
            .frame(width: 138)
        }
    }
    .padding()
}
