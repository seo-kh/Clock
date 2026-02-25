//
//  OpacityContent.swift
//  WatchUI
//
//  Created by alphacircle on 2/25/26.
//

import Foundation
import SwiftUI

struct OpacityContent<Content: WatchContent>: WatchContent {
    let opacity: Double
    let content: () -> Content
    
    func render(_ context: inout GraphicsContext, rect: CGRect) {
        context.opacity = opacity
        
        content()
            .render(&context, rect: rect)
        
        context.opacity = 1.0
    }
}

#Preview {
    Watchface {
        Layer(anchor: .top) {
            ShapeMark(Rectangle(), anchor: .top)
                .style(with: .color(.purple))
                .frame(width: 200, height: 100)
            
            TextMark(text: "opacity: 100%", anchor: .center)
                .offset(y: 50)
        }
        
        Layer(anchor: .center) {
            ShapeMark(Rectangle())
                .style(with: .color(.purple))
                .frame(width: 200, height: 100)
                .opacity(0.4)

            TextMark(text: "opacity: 40%", anchor: .center)
        }
    }
}
