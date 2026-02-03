//
//  Layer.swift
//  Stopwatch
//
//  Created by alphacircle on 2/3/26.
//

import SwiftUI

struct Layer: StopwatchContent {
    private let alignment: Alignment
    private var offset: CGSize
    private var rect: CGRect
    private let contents: [any StopwatchContent]
    
    enum Alignment {
        case topLeading
        case top
        case topTrailing
        case centerLeading
        case center
        case centerTrailing
        case bottomLeading
        case bottom
        case bottomTrailing
    }
    
    init(alignment: Alignment? = nil, @StopwatchContentBuilder _ content: () -> [any StopwatchContent]) {
        self.alignment = alignment ?? .topLeading
        self.offset = CGSize.zero
        self.rect = CGRect.zero
        self.contents = content()
    }

    func draw(_ context: inout GraphicsContext) {
        context.drawLayer { ctx in
            ctx.translateBy(x: rect.minX, y: rect.minY)
            
            for content in contents {
                content
                    .bound(rect)
                    .draw(&ctx)
            }
        }
    }
    
    func bound(_ rect: CGRect) -> Self {
        var _self = self
        
        // real size
        let _size: CGSize = if (self.rect != CGRect.zero) { self.rect.size } else { rect.size }
        _self.rect.size = _size
        
        // align point
        let world: CGRect = CGRect(origin: CGPoint.zero, size: rect.size)
        self.align(rect: &_self.rect, world: world)
        self.translate(rect: &_self.rect)
        
        return _self
    }
    
    func frame(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        let size = CGSize(width: width ?? .zero, height: height ?? .zero)
        var _self = self
        _self.rect.size = size
        return _self
    }

    func offset(x: CGFloat = 0.0, y: CGFloat = 0.0) -> Self {
        let size = CGSize(width: x, height: y)
        return self.offset(size: size)
    }

    func offset(size: CGSize) -> Self {
        var _self = self
        _self.offset = size
        return _self
    }
    
    private func translate(rect: inout CGRect) {
        let transform = CGAffineTransform(translationX: offset.width, y: offset.height)
        rect = rect.applying(transform)
    }
    
    private func align(rect: inout CGRect, world: CGRect) {
        switch alignment {
        case .topLeading:
            rect.origin = CGPoint(x: world.minX, y: world.minY)
        case .top:
            rect.origin = CGPoint(x: world.midX, y: world.minY)
        case .topTrailing:
            rect.origin = CGPoint(x: world.maxX, y: world.minY)
        case .centerLeading:
            rect.origin = CGPoint(x: world.minX, y: world.midY)
        case .center:
            rect.origin = CGPoint(x: world.midX, y: world.midY)
        case .centerTrailing:
            rect.origin = CGPoint(x: world.maxX, y: world.midY)
        case .bottomLeading:
            rect.origin = CGPoint(x: world.minX, y: world.maxY)
        case .bottom:
            rect.origin = CGPoint(x: world.midX, y: world.maxY)
        case .bottomTrailing:
            rect.origin = CGPoint(x: world.maxX, y: world.maxY)
        }
    }
}
