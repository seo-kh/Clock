//
//  TextMark.swift
//  WatchUI
//
//  Created by alphacircle on 2/6/26.
//

import SwiftUI

public struct TextMark: WatchContent {
    private let text: Text
    private let anchor: UnitPoint
    
    public init(anchor: UnitPoint = .center, content: () -> Text) {
        self.text = content()
        self.anchor = anchor
    }
    
    public init(text: String, anchor: UnitPoint = .center) {
        self.init(anchor: anchor, content: { Text(text) })
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        context.draw(self.text, at: rect.origin, anchor: anchor)
    }
}

#Preview("test: one mark render") {
    Watchface {
        Layer {
            TextMark(anchor: .center) {
                Text("Text Mark")
            }
        }
    }
}
