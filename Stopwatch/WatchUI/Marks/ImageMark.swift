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
    var fillStyle: FillStyle
    
    public init(anchor: UnitPoint? = nil, content: () -> Image) {
        self.image = content()
        self.anchor = anchor
        self.fillStyle = FillStyle()
    }
    
    public init(systemName: String, anchor: UnitPoint? = nil) {
        self.init(anchor: anchor, content: { Image(systemName: systemName) })
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        if let anchor {
            context.draw(image, at: rect.origin, anchor: anchor)
        } else {
            context.draw(image, in: rect, style: fillStyle)
        }
    }
}

// MARK: - Modifiers
public extension ImageMark {
    func style(with style: FillStyle) -> Self {
        var _self = self
        _self.fillStyle = style
        return _self
    }
}

#Preview {
    Watchface {
        Layer(anchor: .topLeading) {
            ImageMark {
                Image(systemName: "clock")
            }

            ImageMark(anchor: .topLeading) {
                Image(systemName: "clock")
            }
        }
    }
}
