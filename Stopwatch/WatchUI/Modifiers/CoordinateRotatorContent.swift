//
//  CoordinateRotatorContent.swift
//  WatchUI
//
//  Created by alphacircle on 2/19/26.
//

import Foundation
import SwiftUI

struct CoordinateRotatorContent<Content: WatchContent>: WatchContent {
    let angle: Angle
    let inplace: Bool
    let content: () -> Content
    
    init(angle: Angle, inplace: Bool, content: @escaping () -> Content) {
        self.angle = angle
        self.content = content
        self.inplace = inplace
    }
    
    func render(_ context: inout GraphicsContext, rect: CGRect) {
        context.rotate(by: angle)
        
        content().render(&context, rect: rect)
        
        if inplace {
            context.rotate(by: -angle)
        }
    }
}

public struct _ShapeMark<S: Shape>: WatchContent {
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


#Preview {
    Watchface {
        Layer(alignment: .center) {
            _ShapeMark(Rectangle())
                .frame(width: 30, height: 60)
                .offset(y: -100)
            
            _ShapeMark(Rectangle())
                .frame(width: 30, height: 60)
                .offset(y: -100)
                .coordinateRotation(angle: .degrees(50))
        }
    }
}
