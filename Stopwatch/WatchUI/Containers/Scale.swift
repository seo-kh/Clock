//
//  Scale.swift
//  WatchUI
//
//  Created by alphacircle on 2/19/26.
//

import SwiftUI

public struct Scale<Content: WatchContent>: WatchContent {
    let size: Size
    let content: () -> Content
    
    public init(size: Size, content: @escaping () -> Content) {
        self.size = size
        self.content = content
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        let length: CGFloat = min(rect.width, rect.height)
        let radius: CGFloat = length / 2.0
        let newRect: CGRect = size.makeCGRect(length: radius)

        content()
            .render(&context, rect: newRect)
    }
}

#Preview("equal width") {
    let width: SizeRule = .equal(parts: 60, span: 3)
    let height: SizeRule = .identity
    let y: SizeRule = .identity
    
    Watchface {
        Layer(alignment: .center) {
            Scale(size: .init(y: y, width: width, height: height)) {
                Loop(data: 0..<60) { _ in
                    ShapeMark(Rectangle(), anchor: .top)
                        .style(with: .color(.red))
                        .coordinateRotation(angle: .degrees(360.0 / 60))
                }
            }
        }
    }
}

#Preview("fixed height") {
    let width: SizeRule = .equal(parts: 60, span: 3)
    let height: SizeRule = .fixed(10)
    let y: SizeRule = .identity
    
    Watchface {
        Layer(alignment: .center) {
            Scale(size: .init(y: y, width: width, height: height)) {
                Loop(data: 0..<60) { _ in
                    ShapeMark(Rectangle(), anchor: .top)
                        .style(with: .color(.red))
                        .coordinateRotation(angle: .degrees(360.0 / 60))
                }
            }
        }
    }
}

#Preview("fixed position") {
    let width: SizeRule = .equal(parts: 60, span: 3)
    let height: SizeRule = .fixed(10)
    let y: SizeRule = .fixed(100)
    
    Watchface {
        Layer(alignment: .center) {
            Scale(size: .init(y: y, width: width, height: height)) {
                Loop(data: 0..<60) { _ in
                    ShapeMark(Rectangle(), anchor: .top)
                        .style(with: .color(.red))
                        .coordinateRotation(angle: .degrees(360.0 / 60))
                }
            }
        }
    }
}
