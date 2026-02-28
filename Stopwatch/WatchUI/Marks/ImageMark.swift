//
//  ImageMark.swift
//  WatchUI
//
//  Created by alphacircle on 2/9/26.
//

import SwiftUI

public struct ImageMark: WatchContent {
    let image: Image
    let anchor: UnitPoint
    
    public init(anchor: UnitPoint = .center, content: () -> Image) {
        self.image = content()
        self.anchor = anchor
    }
    
    public init(systemName: String, anchor: UnitPoint = .center) {
        self.init(anchor: anchor, content: { Image(systemName: systemName) })
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        context.draw(image, at: rect.origin, anchor: anchor)
    }
}

#Preview {
    Watchface {
        Layer(anchor: .center) {
            ImageMark {
                Image(systemName: "clock")
            }
            .frame(width: 50, height: 50)

            ImageMark(anchor: .topLeading) {
                Image(systemName: "clock")
            }
            .frame(width: 50, height: 50)
        }
    }
}
