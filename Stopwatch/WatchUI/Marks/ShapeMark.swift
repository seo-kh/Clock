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
        let newRect = self.align(from: rect)
        context.fill(shape.path(in: newRect), with: shading)
    }
}

public extension ShapeMark {
    func style(with shading: GraphicsContext.Shading) -> some WatchContent {
        ShapeMark(self.shape, anchor: self.anchor, shading: shading)
    }
}

extension ShapeMark {
    func align(from rect: CGRect) -> CGRect {
        let transform: CGAffineTransform =
        switch anchor {
        case .topLeading: .init(translationX: -rect.minX, y: rect.minY)
        case .top: .init(translationX: -rect.midX, y: -rect.minY)
        case .topTrailing: .init(translationX: -rect.maxX, y: -rect.minY)
        case .leading: .init(translationX: -rect.minX, y: -rect.midY)
        case .center: .init(translationX: -rect.midX, y: -rect.midY)
        case .trailing: .init(translationX: -rect.maxX, y: -rect.midY)
        case .bottomLeading: .init(translationX: -rect.minX, y: -rect.maxY)
        case .bottom: .init(translationX: -rect.midX, y: -rect.maxY)
        case .bottomTrailing: .init(translationX: -rect.maxX, y: -rect.maxY)
        default: .init(translationX: .zero, y: .zero)
        }
        
        return rect.applying(transform)
    }
}

#Preview {
    Watchface {
        Layer(alignment: .center) {
            ShapeMark(Rectangle())
                .frame(width: 100, height: 50)
                .offset(y: -50)
            
            ShapeMark(Rectangle(), anchor: .center)
                .frame(width: 100, height: 50)
        }
    }
}
