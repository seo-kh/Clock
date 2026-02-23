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
    let content: (Int) -> Content
    
    public init(total: Int, span: Int = 1, content: @escaping (Int) -> Content) {
        self.total = max(total, 1)
        self.span = max(span, 1)
        self.aspectRatio = 1.0 / 1.0
        self.content = content
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        // degree
        let newRect = self.align(from: rect)

        for i in 0..<total {
            content(i)
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
    /// 가로 / 세로 비율
    func aspectRatio(_ aspectRatio: CGFloat) -> Self {
        var _self = self
        _self.aspectRatio = aspectRatio
        return _self
    }
}

#Preview {
    Watchface {
        Layer(alignment: .center) {
            Scale(total: 240, span: 2) { i in
                ShapeMark(Rectangle())
                    .style(with: .color(.red))
                    .coordinateRotation(angle: .degrees(360.0 / 240.0))
            }
            .aspectRatio(1.0 / 3.0)
        }
    }
}
