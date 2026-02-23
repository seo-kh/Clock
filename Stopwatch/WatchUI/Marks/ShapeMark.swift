//
//  ShapeMark.swift
//  WatchUI
//
//  Created by alphacircle on 2/19/26.
//

import SwiftUI

public struct ShapeMark<S: Shape>: WatchContent {
    private let shape: S
    private let shading: GraphicsContext.Shading
    
    init(_ shape: S, shading: GraphicsContext.Shading) {
        self.shape = shape
        self.shading = shading
    }
    
    public init(_ shape: S) {
        self.init(shape, shading: .foreground)
    }

    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        context.fill(shape.path(in: rect), with: shading)
    }
}

public extension ShapeMark {
    func style(with shading: GraphicsContext.Shading) -> ShapeMark {
        ShapeMark(self.shape, shading: shading)
    }
    
    func align(_ anchor: UnitPoint) -> some WatchContent {
        Align(anchor: anchor, content: { self })
    }
}

extension ShapeMark {
    struct Align<Content: WatchContent>: WatchContent {
        let anchor: UnitPoint
        let content: () -> Content
        
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
        
        public func render(_ context: inout GraphicsContext, rect: CGRect) {
            
            let delta = self.delta(from: rect)
            var newRect = rect
            newRect.origin.x += -delta.x
            newRect.origin.y += -delta.y
            
            content()
                .render(&context, rect: newRect)
        }
    }
}

#Preview {
    Watchface {
        Layer(alignment: .center) {
            ShapeMark(Rectangle())
                .style(with: .color(.red))
                .frame(width: 50, height: 50)
            
            ShapeMark(Rectangle())
                .style(with: .color(.orange))
                .align(.top)
                .frame(width: 50, height: 50)
            
            ShapeMark(Rectangle())
                .style(with: .color(.yellow))
                .align(.topTrailing)
                .frame(width: 50, height: 50)
            
            ShapeMark(Rectangle())
                .style(with: .color(.green))
                .align(.leading)
                .frame(width: 50, height: 50)
            
            ShapeMark(Rectangle())
                .style(with: .color(.cyan))
                .align(.center)
                .frame(width: 50, height: 50)
            
            ShapeMark(Rectangle())
                .style(with: .color(.blue))
                .align(.trailing)
                .frame(width: 50, height: 50)
            
            ShapeMark(Rectangle())
                .style(with: .color(.pink))
                .align(.bottomLeading)
                .frame(width: 50, height: 50)
            
            ShapeMark(Rectangle())
                .style(with: .color(.purple))
                .align(.bottom)
                .frame(width: 50, height: 50)
            
            ShapeMark(Rectangle())
                .style(with: .color(.indigo))
                .align(.bottomTrailing)
                .frame(width: 50, height: 50)
        }
    }
}
