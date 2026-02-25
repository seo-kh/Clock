//
//  ShapeMark.swift
//  WatchUI
//
//  Created by alphacircle on 2/19/26.
//

import SwiftUI

public struct ShapeMark<S: Shape>: WatchContent {
    let shape: S
    let anchor: UnitPoint
    let shading: GraphicsContext.Shading
    
    init(_ shape: S, anchor: UnitPoint, shading: GraphicsContext.Shading) {
        self.shape = shape
        self.anchor = anchor
        self.shading = shading
    }
    
    public init(_ shape: S, anchor: UnitPoint = .center) {
        self.init(shape, anchor: anchor, shading: .foreground)
    }

    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        let newRect = anchor.alignAnchorPoint(to: rect)
        context.fill(shape.path(in: newRect), with: shading)
    }
}

public extension ShapeMark {
    func style(with shading: GraphicsContext.Shading) -> ShapeMark {
        ShapeMark(self.shape, anchor: self.anchor, shading: shading)
    }
}

#Preview("shape anchor test") {
    Watchface {
        Layer(anchor: .center) {
            ShapeMark(Rectangle(), anchor: .topLeading)
                .style(with: .color(.red))
                .frame(width: 50, height: 50)
            
            ShapeMark(Rectangle(), anchor: .top)
                .style(with: .color(.orange))
                .frame(width: 50, height: 50)
            
            ShapeMark(Rectangle(), anchor: .topTrailing)
                .style(with: .color(.yellow))
                .frame(width: 50, height: 50)
            
            ShapeMark(Rectangle(), anchor: .leading)
                .style(with: .color(.green))
                .frame(width: 50, height: 50)
            
            ShapeMark(Rectangle(), anchor: .center)
                .style(with: .color(.cyan))
                .frame(width: 50, height: 50)
            
            ShapeMark(Rectangle(), anchor: .trailing)
                .style(with: .color(.blue))
                .frame(width: 50, height: 50)
            
            ShapeMark(Rectangle(), anchor: .bottomLeading)
                .style(with: .color(.pink))
                .frame(width: 50, height: 50)
            
            ShapeMark(Rectangle(), anchor: .bottom)
                .style(with: .color(.purple))
                .frame(width: 50, height: 50)
            
            ShapeMark(Rectangle(), anchor: .bottomTrailing)
                .style(with: .color(.indigo))
                .frame(width: 50, height: 50)
        }
    }
}
