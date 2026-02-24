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
        let width: CGFloat = size.width.transform(from: radius)
        let height: CGFloat = size.height.transform(from: radius)
        let position: CGFloat = size.position.transform(from: radius)
        
        var newRect: CGRect = rect
        newRect.size.width = width
        newRect.size.height = height
        newRect.origin.y = -position
        
        content()
            .render(&context, rect: newRect)
    }
}

public extension Scale {
    struct Size {
        let width: SizeRule
        let height: SizeRule
        let position: SizeRule
        
        public init(width: SizeRule = .identity, height: SizeRule = .identity, position: SizeRule = .identity) {
            self.width = width
            self.height = height
            self.position = position
        }
    }
}


#Preview("equal width") {
    let width: SizeRule = .equal(parts: 60, span: 3)
    let height: SizeRule = .identity
    let position: SizeRule = .identity
    
    Watchface {
        Layer(alignment: .center) {
            Scale(size: .init(width: width, height: height, position: position)) {
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
    let position: SizeRule = .identity
    
    Watchface {
        Layer(alignment: .center) {
            Scale(size: .init(width: width, height: height, position: position)) {
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
    let position: SizeRule = .fixed(100)
    
    Watchface {
        Layer(alignment: .center) {
            Scale(size: .init(width: width, height: height, position: position)) {
                Loop(data: 0..<60) { _ in
                    ShapeMark(Rectangle(), anchor: .top)
                        .style(with: .color(.red))
                        .coordinateRotation(angle: .degrees(360.0 / 60))
                }
            }
        }
    }
}
