//
//  Hand.swift
//  WatchUI
//
//  Created by alphacircle on 2/23/26.
//

import Foundation
import SwiftUI

public struct Hand<T: WatchContent>: WatchContent {
    let size: Size
    let content: () -> T
    
    public init(size: Size, content: @escaping () -> T) {
        self.size = size
        self.content = content
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        let length = min(rect.width, rect.height)
        let radius = length / 2.0
        let newRect = size.makeCGRect(length: radius)
        
        content()
            .render(&context, rect: newRect)
    }
}

#Preview {
    Watchface {
        Layer(anchor: .center) {
            Hand(size: .init(width: .equal(parts: 180))) {
                ShapeMark(Rectangle(), anchor: .top)
                    .style(with: .color(.orange))
                    .coordinateRotation(angle: .degrees(120))
            }
            .frame(width: 138, height: 138)
        }
        
        Layer(anchor: .center) {
            Scale(size: .init(width: .equal(parts: 60, span: 3))) {
                Loop(data: 0..<60) { _ in
                    ShapeMark(Rectangle(), anchor: .top)
                        .style(with: .color(.gray))
                        .aspectRatio(1.0 / 3.0)
                        .coordinateRotation(angle: .degrees(360.0 / 60.0))
                }
            }
            .frame(width: 138)
        }
        
        Layer(anchor: .center) {
            ShapeMark(Circle(), anchor: .center)
                .style(with: .color(.orange))
                .frame(width: 6, height: 6)
        }

    }
    .padding()
}
