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
    let content: () -> Content
    
    func render(_ context: inout GraphicsContext, rect: CGRect) {
        var newRect: CGRect = rect
        newRect.origin.x += offset.x
        newRect.origin.y += offset.y

        content()
            .render(&context, rect: newRect)
    }
}

#Preview {
    Watchface {
        Layer(anchor: .center) {
            TextMark(text: "center", anchor: .center)
            
            TextMark(text: "offset y: -50", anchor: .center)
                .offset(y: -50)
            
            TextMark(text: "offset x: -50, y: 50", anchor: .center)
                .offset(x: -150, y: 50)
        }
    }
}
