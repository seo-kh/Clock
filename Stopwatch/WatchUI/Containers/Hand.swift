//
//  Hand.swift
//  WatchUI
//
//  Created by alphacircle on 2/23/26.
//

import Foundation
import SwiftUI

public struct Hand<T: WatchContent>: WatchContent {
    let width: Width
    let height: Height
    let content: () -> T
    
    public init(width: Width, height: Height = .fit, content: @escaping () -> T) {
        self.width = width
        self.height = height
        self.content = content
    }
    
    public enum Width {
        case fixed(CGFloat)
        case equally(CGFloat)
    }
    
    public enum Height {
        case fit
        case fixed(CGFloat)
        case propotional(CGFloat)
    }

    func align(from src: CGRect) -> CGRect {
        let radius = min(src.width, src.height) / 2.0
        var _rect = src
        _rect.origin.y -= radius

        switch width {
        case .fixed(let length):
            _rect.size.width = length
            _rect.origin.x -= length / 2.0
        case .equally(let count):
            let _width = 2.0 * CGFloat.pi * radius / count
            _rect.size.width = _width
            _rect.origin.x -= _width / 2.0
        }
        
        switch height {
        case .fit:
            _rect.size.height = radius
        case .fixed(let _height):
            _rect.size.height = _height
        case .propotional(let ratio):
            _rect.size.height = radius * ratio
        }
        
        return _rect
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        let newRect = self.align(from: rect)
        
        content()
            .render(&context, rect: newRect)
    }
}

#Preview {
    Watchface {
        Layer(alignment: .center) {
            Scale(total: 60, span: 3) {
                ShapeMark(Rectangle())
                    .style(with: .color(.gray))
            }
            .aspectRatio(1.0 / 3.0)
            .frame(width: 138)
            
            Scale(total: 30, span: 6) {
                ShapeMark(Rectangle())
                    .style(with: .color(.gray))
            }
            .aspectRatio(1.0 / 6.0)
            .frame(width: 138)
            
            Scale(total: 6, span: 30) {
                ShapeMark(Rectangle())
                    .style(with: .color(.white))
            }
            .aspectRatio(1.0 / 6.0)
            .frame(width: 138)
            
            Hand(width: .equally(180), height: .propotional(1.2)) {
                ShapeMark(Rectangle())
                    .style(with: .color(.orange))
            }
            .frame(width: 138)
            .coordinateRotation(angle: .degrees(30))
        }
    }
}
