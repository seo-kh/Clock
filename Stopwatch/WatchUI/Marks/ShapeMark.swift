//
//  ShapeMark.swift
//  WatchUI
//
//  Created by alphacircle on 2/19/26.
//

import SwiftUI

public struct ShapeMark<S: Shape>: WatchContent {
    private let shape: S
    private var shading: GraphicsContext.Shading
    
    public init(_ shape: S) {
        self.shape = shape
        self.shading = GraphicsContext.Shading.foreground
    }

    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        context.fill(shape.path(in: rect), with: shading)
    }
    
}

// MARK: - Modifiers
public extension ShapeMark {
    func style(with shading: GraphicsContext.Shading) -> Self {
        var _self = self
        _self.shading = shading
        return _self
    }
}

