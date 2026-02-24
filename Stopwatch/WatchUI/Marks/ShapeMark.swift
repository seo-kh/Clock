//
//  ShapeMark.swift
//  WatchUI
//
//  Created by alphacircle on 2/19/26.
//

import SwiftUI

public struct ShapeMark<S: Shape>: WatchContent {
    private let shape: S
    private let anchor: UnitPoint
    private let shading: GraphicsContext.Shading
    
    init(_ shape: S, anchor: UnitPoint, shading: GraphicsContext.Shading) {
        self.shape = shape
        self.anchor = anchor
        self.shading = shading
    }
    
    public init(_ shape: S, anchor: UnitPoint = .topLeading) {
        self.init(shape, anchor: anchor, shading: .foreground)
    }

    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        let delta = self.delta(from: rect)
        var newRect = rect
        self.align(&newRect, to: delta)
        context.fill(shape.path(in: newRect), with: shading)
    }
}

public extension ShapeMark {
    func style(with shading: GraphicsContext.Shading) -> ShapeMark {
        ShapeMark(self.shape, anchor: self.anchor, shading: shading)
    }
}

extension ShapeMark {
    func delta(from rect: CGRect) -> (x: CGFloat, y: CGFloat) {
        let minX = 0.0
        let minY = 0.0
        let midX = rect.width / 2.0
        let midY = rect.height / 2.0
        let maxX = rect.width
        let maxY = rect.height
        
        return switch anchor {
        case .topLeading: (minX, minY)
        case .top: (midX, minY)
        case .topTrailing: (maxX, minY)
            
        case .leading: (minX, midY)
        case .center: (midX, midY)
        case .trailing: (maxX, midY)
            
        case .bottomLeading: (minX, maxY)
        case .bottom: (midX, maxY)
        case .bottomTrailing: (maxX, maxY)
            
        default: (0, 0)
        }
    }
        
    func align(_ rect: inout CGRect, to delta: (x: CGFloat, y: CGFloat)) {
        
        rect.origin.x += -delta.x
        rect.origin.y += -delta.y
    }
            
}

#Preview {
    Watchface {
        Layer(alignment: .center) {
            ShapeMark(Rectangle())
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
