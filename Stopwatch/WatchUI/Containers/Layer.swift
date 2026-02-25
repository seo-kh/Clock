//
//  Layer.swift
//  WatchUI
//
//  Created by alphacircle on 2/12/26.
//

import SwiftUI

extension GraphicsContext {
    mutating func translateBy(_ point: CGPoint) {
        self.translateBy(x: point.x, y: point.y)
    }
}

public struct Layer<Content: WatchContent>: WatchContent, AlignmentRule {
    let anchor: UnitPoint
    let content: () -> Content
    
    public init(anchor: UnitPoint = .center, @WatchContentBuilder content: @escaping () -> Content) {
        self.anchor = anchor
        self.content = content
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        context.drawLayer { layerContext in
            layerContext
                .translateBy(self.alignOrigin(to: rect))
            
            content()
                .render(&layerContext, rect: rect)
        }
    }
}

#Preview("test: layer mark render") {
    Watchface {
        Layer(anchor: .top) {
            TextMark(anchor: .center) {
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

#Preview("fix") {
    Watchface {
        // Minute Scale
        Layer(anchor: .center) {
            Scale(0..<60, span: 3) { i in
                ShapeMark(Rectangle(), anchor: .top)
                    .style(with: .color(i.isMultiple(of: 10) ? .white : .gray))
                    .aspectRatio(i.isMultiple(of: 2) ? 1.0 / 6.0 : 1.0 / 3.0)
            }
            .scale(0.30)
        }
        .offset(y: -75)

        // Minute Hand
        Layer(anchor: .center) {
            Hand(size: .init(width: .equal(parts: 180))) {
                ShapeMark(Rectangle(), anchor: .top)
                    .style(with: .color(.orange))
                    .coordinateRotation(angle: .radians(1))
            }
            .scale(0.30)
        }
        .offset(y: -75)
        
        // Minute Hand Center
        Layer(anchor: .center) {
            ShapeMark(Circle(), anchor: .center)
                .style(with: .color(.orange))
                .frame(width: 6, height: 6)
                .offset(y: -75)
        }
    }
}
