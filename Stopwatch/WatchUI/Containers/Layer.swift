//
//  Layer.swift
//  WatchUI
//
//  Created by alphacircle on 2/12/26.
//

import SwiftUI

public struct Layer<Content: WatchContent>: WatchContent {
    let alignment: Alignment
    let content: () -> Content
    
    public init(alignment: Alignment = .center, @WatchContentBuilder content: @escaping () -> Content) {
        self.alignment = alignment
        self.content = content
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        context.drawLayer { layerContext in
            let newPoint = self.align(from: rect)
            
            layerContext
                .translateBy(x: newPoint.x, y: newPoint.y)
            
            content()
                .render(&layerContext, rect: rect)
        }
    }
    
    private func align(from src: CGRect) -> CGPoint {
        switch alignment {
        case .topLeading: CGPoint(x: src.minX, y: src.minY)
        case .top: CGPoint(x: src.midX, y: src.minY)
        case .topTrailing: CGPoint(x: src.maxX, y: src.midY)
            
        case .leading: CGPoint(x: src.minX, y: src.midY)
        case .center: CGPoint(x: src.midX, y: src.midY)
        case .trailing: CGPoint(x: src.maxX, y: src.midY)
            
        case .bottomLeading: CGPoint(x: src.minX, y: src.maxY)
        case .bottom: CGPoint(x: src.midX, y: src.maxY)
        case .bottomTrailing: CGPoint(x: src.maxX, y: src.maxY)
            
        default: CGPoint(x: src.minX, y: src.minY)
        }
    }
}

#Preview("test: layer mark render") {
    Watchface {
        Layer(alignment: .top) {
            TextMark(anchor: .center) {
                Text("Top")
                    .foregroundStyle(.yellow)
            }
        }
        
        Layer(alignment: .center) {
            TextMark(anchor: .center) {
                Text("Center")
            }
        }
    }
}
