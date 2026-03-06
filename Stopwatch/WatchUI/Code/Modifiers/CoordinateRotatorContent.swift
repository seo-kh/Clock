//
//  CoordinateRotatorContent.swift
//  WatchUI
//
//  Created by alphacircle on 2/19/26.
//

import Foundation
import SwiftUI

struct CoordinateRotatorContent<Content: WatchContent>: WatchContent {
    let angle: Angle
    let content: () -> Content
    
    init(angle: Angle, content: @escaping () -> Content) {
        self.angle = angle
        self.content = content
    }
    
    func render(_ context: inout GraphicsContext, rect: CGRect) {
        context
            .rotate(by: angle)
        
        content()
            .render(&context, rect: rect)
    }
}

#Preview {
    Watchface {
        Layer(anchor: .center) {
            ShapeMark(Rectangle())
                .frame(width: 30, height: 60)
                .offset(y: -100)
            
            ShapeMark(Rectangle())
                .frame(width: 30, height: 60)
                .offset(y: -100)
                .coordinateRotation(angle: .degrees(50))
        }
    }
}
