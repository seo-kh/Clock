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
    func style(with shading: GraphicsContext.Shading) -> some WatchContent {
        ShapeMark(self.shape, shading: shading)
    }
}
