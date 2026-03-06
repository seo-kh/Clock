//
//  ShapeMark.swift
//  WatchUI
//
//  Created by alphacircle on 2/19/26.
//

import SwiftUI

/// Shape을 그려내는 마크 콘텐츠
///
/// SwiftUI Shape 렌더링
///
/// ```swift
/// Watchface {
///     Layer(anchor: .center) {
///         ShapeMark(Rectangle(), anchor: .topLeading)
///             .style(with: .color(.red))
///             .frame(width: 50, height: 50)
///
///         ShapeMark(Rectangle(), anchor: .top)
///             .style(with: .color(.orange))
///             .frame(width: 50, height: 50)
///
///         ShapeMark(Rectangle(), anchor: .topTrailing)
///             .style(with: .color(.yellow))
///             .frame(width: 50, height: 50)
///
///         ShapeMark(Rectangle(), anchor: .leading)
///             .style(with: .color(.green))
///             .frame(width: 50, height: 50)
///
///         ShapeMark(Rectangle(), anchor: .center)
///             .style(with: .color(.cyan))
///             .frame(width: 50, height: 50)
///
///         ShapeMark(Rectangle(), anchor: .trailing)
///             .style(with: .color(.blue))
///             .frame(width: 50, height: 50)
///
///         ShapeMark(Rectangle(), anchor: .bottomLeading)
///             .style(with: .color(.pink))
///             .frame(width: 50, height: 50)
///
///         ShapeMark(Rectangle(), anchor: .bottom)
///             .style(with: .color(.purple))
///             .frame(width: 50, height: 50)
///
///         ShapeMark(Rectangle(), anchor: .bottomTrailing)
///             .style(with: .color(.indigo))
///             .frame(width: 50, height: 50)
///     }
/// }
/// ```
///
/// 위 코드는 anchor에 따른 렌더링의 차이를 보여주는 예시입니다.
///
/// ![An image of shape watch content](shape.png)
public struct ShapeMark<S: Shape>: WatchContent {
    let shape: S
    let anchor: UnitPoint
    let shading: GraphicsContext.Shading
    
    init(_ shape: S, anchor: UnitPoint, shading: GraphicsContext.Shading) {
        self.shape = shape
        self.anchor = anchor
        self.shading = shading
    }
    
    /// 기본 이니셜라이저
    /// - Parameters:
    ///   - shape: 그릴 SwiftUI Shape
    ///   - anchor: 드로잉 기준점
    ///
    /// ```swift
    /// ShapeMark(Rectangle(), anchor: .top)
    ///     .style(with: .color(.red))
    ///     .frame(width: 4, height: 60)
    /// ```
    public init(_ shape: S, anchor: UnitPoint = .center) {
        self.init(shape, anchor: anchor, shading: .foreground)
    }

    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        let newRect = anchor.alignAnchorPoint(to: rect)
        context.fill(shape.path(in: newRect), with: shading)
    }
}

public extension ShapeMark {
    /// 새로운 shading 적용
    /// - Parameter shading: 새 shading
    /// - Returns: 새로운 ShapeMark
    func style(with shading: GraphicsContext.Shading) -> ShapeMark {
        ShapeMark(self.shape, anchor: self.anchor, shading: shading)
    }
}

#Preview("shape anchor test") {
    Watchface {
        Layer(anchor: .center) {
            ShapeMark(Rectangle(), anchor: .topLeading)
                .style(with: .color(.red))
                .frame(width: 50, height: 50)
            
            ShapeMark(Rectangle(), anchor: .top)
                .style(with: .color(.orange))
                .frame(width: 50, height: 50)
            
            ShapeMark(Rectangle(), anchor: .topTrailing)
                .style(with: .color(.yellow))
                .frame(width: 50, height: 50)
            
            ShapeMark(Rectangle(), anchor: .leading)
                .style(with: .color(.green))
                .frame(width: 50, height: 50)
            
            ShapeMark(Rectangle(), anchor: .center)
                .style(with: .color(.cyan))
                .frame(width: 50, height: 50)
            
            ShapeMark(Rectangle(), anchor: .trailing)
                .style(with: .color(.blue))
                .frame(width: 50, height: 50)
            
            ShapeMark(Rectangle(), anchor: .bottomLeading)
                .style(with: .color(.pink))
                .frame(width: 50, height: 50)
            
            ShapeMark(Rectangle(), anchor: .bottom)
                .style(with: .color(.purple))
                .frame(width: 50, height: 50)
            
            ShapeMark(Rectangle(), anchor: .bottomTrailing)
                .style(with: .color(.indigo))
                .frame(width: 50, height: 50)
        }
    }
}
