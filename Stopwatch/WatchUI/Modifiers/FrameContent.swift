//
//  FrameContent.swift
//  WatchUI
//
//  Created by 테스트 on 2/19/26.
//

import SwiftUI
import Foundation

struct FrameContent<Content: WatchContent>: WatchContent {
    let widthRule: SizeRule
    let heightRule: SizeRule
    let content: () -> Content
    
    func render(_ context: inout GraphicsContext, rect: CGRect) {
        var newRect = rect
        newRect.size.width = widthRule.transform(from: rect.width)
        newRect.size.height = heightRule.transform(from: rect.height)
        
        content()
            .render(&context, rect: newRect)
    }
}
#Preview {
    Watchface {
        Layer(alignment: .center) {
            Scale(total: 60, span: 3) { i in
                ShapeMark(Rectangle())
                    .coordinateRotation(angle: .degrees(360.0 / 60))
            }
            .aspectRatio(1.0 / 3.0)
            .frame(width: 200, height: 200)
        }
    }
}
