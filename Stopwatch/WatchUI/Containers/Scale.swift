//
//  Scale.swift
//  WatchUI
//
//  Created by alphacircle on 2/19/26.
//

import SwiftUI

public struct Scale<Content: WatchContent>: WatchContent {
    let total: Int
    let span: Int
    var aspectRatio: CGFloat
    let array: ArrayContent
    
    public init(total: Int, span: Int = 1, content: () -> Content) {
        self.total = max(total, 1)
        self.span = max(span, 1)
        self.aspectRatio = 1.0 / 1.0
        self.array = ArrayContent(repeating: content(), count: self.total)
    }
    
    public init(span: Int = 1, @WatchContentBuilder content: () -> Content) where Content == ArrayContent {
        let array = content()
        self.init(total: array.count, span: span, content: { array })
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        // degree
        let angle = Angle.degrees(360.0 / Double(total))
        let newRect = self.align(from: rect)

        for content in array.contents {
            content
                .coordinateRotation(angle: angle) // rotate
                .render(&context, rect: newRect)
        }
    }
    
    /// scale의 Rect 정보 계산
    ///
    /// - width: 2π * r / total count
    /// - height: width / aspect ratio
    /// - origin: top (center x, top y)
    private func align(from src: CGRect) -> CGRect {
        let radius = min(src.size.height, src.size.width) / 2.0
        
        // content spec
        let contentWidth = 2.0 * CGFloat.pi * radius / Double(total * span)
        let contentHeight = contentWidth / aspectRatio
        let contentSize = CGSize(width: contentWidth, height: contentHeight)
        let contentPoint = CGPoint(x: -contentWidth / 2.0, y: -radius)
        let contentRect = CGRect(origin: contentPoint, size: contentSize)
        
        return contentRect
    }
}

// MARK: - Modifiers
public extension Scale {
    func apply(_ aspectRatio: CGFloat) -> Self {
        var _self = self
        _self.aspectRatio = aspectRatio
        return _self
    }
}

#Preview {
    Watchface {
        Layer(alignment: .center) {
            Scale(total: 240, span: 2) {
                ShapeMark(Rectangle())
                    .apply(.color(.red))
            }
            .apply(1.0 / 3.0)
        }
    }
}
