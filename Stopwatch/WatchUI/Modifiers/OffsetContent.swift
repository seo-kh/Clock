//
//  OffsetContent.swift
//  WatchUI
//
//  Created by alphacircle on 2/19/26.
//

import Foundation
import SwiftUI

struct OffsetContent<Content: WatchContent>: WatchContent {
    let offset: CGPoint
    let inplace: Bool
    let content: () -> Content
    
    func render(_ context: inout GraphicsContext, rect: CGRect) {
        context.translateBy(x: offset.x, y: offset.y)

        content()
            .render(&context, rect: rect)
        
        if !inplace {
            context.translateBy(x: -offset.x, y: -offset.y)
        }
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
            .offset(y: -76)
        }
    }
}
