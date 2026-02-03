//
//  Mark.swift
//  Stopwatch
//
//  Created by alphacircle on 2/3/26.
//

import SwiftUI

struct Mark: StopwatchContent, StopwatchStyle {
    private var kind: Kind
    private var shading: GraphicsContext.Shading
    private var rect: CGRect
    
    enum Kind {
        case path(Path)
        case shape(any Shape)
        case text(Text)
        case image(Image)
    }
    
    init(kind: Kind) {
        self.kind = kind
        self.shading = .color(.black)
        self.rect = CGRect.zero
    }

    func bound(_ rect: CGRect) -> Self {
        var _self = self
        _self.rect = rect
        return _self
    }

    func style(with shading: GraphicsContext.Shading) -> Self {
        var _self = self
        _self.shading = shading
        return _self
    }
    
    func draw(_ context: inout GraphicsContext) {
        switch kind {
        case .path(let path):
            context.fill(path, with: shading)
        case .shape(let shape):
            context.fill(shape.path(in: rect), with: shading)
        case .text(let text):
            context.draw(text, in: rect)
        case .image(let image):
            context.draw(image, in: rect)
        }
    }
}

