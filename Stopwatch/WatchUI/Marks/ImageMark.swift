//
//  ImageMark.swift
//  WatchUI
//
//  Created by alphacircle on 2/9/26.
//

import SwiftUI

public struct ImageMark: WatchContent {
    let image: Image
    let anchor: UnitPoint?
    var style: FillStyle
    
    public init(anchor: UnitPoint? = nil, content: () -> Image) {
        self.image = content()
        self.anchor = anchor
        self.style = FillStyle()
    }
    
    public init(systemName: String, anchor: UnitPoint? = nil) {
        self.init(anchor: anchor, content: { Image(systemName: systemName) })
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        if let anchor {
            context.draw(image, at: rect.origin, anchor: anchor)
        } else {
            context.draw(image, in: rect, style: style)
        }
    }
}

// MARK: - Modifiers
public extension ImageMark {
    func apply(_ style: FillStyle) -> Self {
        var _self = self
        _self.style = style
        return _self
    }
}

#Preview {
    Watchface {
        ImageMark(anchor: .topLeading) {
            Image(systemName: "circle")
        }
    }
}
