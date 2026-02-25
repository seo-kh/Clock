//
//  Layer.swift
//  WatchUI
//
//  Created by alphacircle on 2/12/26.
//

import SwiftUI

public struct Layer<Content: WatchContent>: WatchContent {
    let anchor: UnitPoint
    let content: () -> Content
    
    public init(anchor: UnitPoint = .center, @WatchContentBuilder content: @escaping () -> Content) {
        self.anchor = anchor
        self.content = content
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        context.drawLayer { layerContext in
            let point = anchor.alignOriginPoint(to: rect)
            
            layerContext
                .translateBy(x: point.x, y: point.y)
            
            content()
                .render(&layerContext, rect: rect)
        }
    }
}

#Preview("demo") {
    Watchface {
        let data: [(anchor: UnitPoint, color: Color)] = [
            (UnitPoint(x: 0.25, y: 0.25), Color.red),
            (UnitPoint(x: 0.50, y: 0.25), Color.orange),
            (UnitPoint(x: 0.75, y: 0.25), Color.yellow),
            
            (UnitPoint(x: 0.25, y: 0.50), Color.green),
            (UnitPoint(x: 0.50, y: 0.50), Color.cyan),
            (UnitPoint(x: 0.75, y: 0.50), Color.blue),
            
            (UnitPoint(x: 0.25, y: 0.75), Color.indigo),
            (UnitPoint(x: 0.50, y: 0.75), Color.pink),
            (UnitPoint(x: 0.75, y: 0.75), Color.purple),
        ]
        
        Loop(data: data) { element in
            Layer(anchor: element.anchor) {
                ShapeMark(Circle(), anchor: .center)
                    .style(with: .color(element.color))
                    .frame(width: 80, height: 80)
            }
        }
    }
}

#Preview("layer mark render") {
    Watchface {
        Layer(anchor: .top) {
            TextMark(anchor: .top) {
                Text("Top")
                    .foregroundStyle(.yellow)
            }
        }
        
        Layer(anchor: .center) {
            TextMark(anchor: .center) {
                Text("Center")
            }
        }
        
        Layer(anchor: .init(x: 0.75, y: 0.35)) {
            TextMark(anchor: .center) {
                Text("**Center**")
            }
        }
    }
}
