//
//  Scale.swift
//  WatchUI
//
//  Created by alphacircle on 2/19/26.
//

import SwiftUI

public struct Scale<Content: WatchContent>: WatchContent {
    let size: SizeRule
    let content: () -> Content
    
    public init(size: SizeRule, content: @escaping () -> Content) {
        self.size = size
        self.content = content
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        let length = min(rect.width, rect.height)
        let radius = length / 2.0
        let width = size.transform(from: length)
        
        var newRect = rect
        newRect.size.width = width
        newRect.size.height = radius
        newRect.origin.y = -radius
        
        content()
            .render(&context, rect: newRect)
    }
}

public extension Scale {
    init<D, C>(_ data: D, span: Int = 1, content: @escaping (D.Element) -> C) where D: RandomAccessCollection, C: WatchContent, Content == AnyWatchContent {
        let parts: CGFloat = CGFloat(data.count)
        self.init(size: .equal(parts: parts, span: CGFloat(span))) {
            AnyWatchContent(content: Loop(data: data) { ele in
                    content(ele)
                        .coordinateRotation(angle: Angle.degrees(360.0 / parts))
                }
            )
        }
    }
}


#Preview {
    Watchface {
        Layer(alignment: .center) {
            Scale(0..<240, span: 2) { _ in
                ShapeMark(Rectangle())
                    .style(with: .color(.red))
                    .align(.top)
                    .aspectRatio(1.0 / 3.0)
            }
        }
    }
}
