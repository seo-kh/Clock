//
//  ScaleContent.swift
//  WatchUI
//
//  Created by alphacircle on 2/24/26.
//

import Foundation
import SwiftUI

struct ScaleContent<Content: WatchContent>: WatchContent {
    let size: CGSize
    let content: () -> Content
    
    init(_ size: CGSize, content: @escaping () -> Content) {
        self.size = size
        self.content = content
    }
    
    func render(_ context: inout GraphicsContext, rect: CGRect) {
        var newRect = rect
        let newSize = rect.size.applying(.init(scaleX: size.width, y: size.height))
        newRect.size = newSize
        
        content()
            .render(&context, rect: newRect)
    }
}

#Preview("multi scale") {
    Watchface {
        Layer {
            ShapeMark(Rectangle())
                .frame(width: 100, height: 50)
            
            ShapeMark(Rectangle())
                .style(with: .color(.brown))
                .scale(CGSize(width: 2, height: 0.5))
                .frame(width: 100, height: 50)
        }
    }
}

#Preview("unit scale") {
    Watchface {
        Layer {
            ShapeMark(Circle())
                .style(with: .color(.red))
            
            ShapeMark(Circle())
                .style(with: .color(.yellow))
                .scale(0.8)
            
            ShapeMark(Circle())
                .style(with: .color(.blue))
                .scale(0.6)
        }
    }
}
