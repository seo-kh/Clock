//
//  TextMark.swift
//  WatchUI
//
//  Created by alphacircle on 2/6/26.
//

import SwiftUI

public struct TextMark: WatchContent {
    private let text: Text
    private let anchor: UnitPoint?
    
    public init(anchor: UnitPoint? = nil, content: () -> Text) {
        self.text = content()
        self.anchor = anchor
    }
    
    public init(text: String, anchor: UnitPoint? = nil) {
        self.init(anchor: anchor, content: { Text(text) })
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        if let anchor {
            context.draw(self.text, at: rect.origin, anchor: anchor)
        } else {
            context.draw(self.text, in: rect)
        }
    }
}

#Preview("test: one mark render") {
    Watchface {
        TextMark(anchor: .topLeading) {
            Text("Text Mark")
        }
    }
}
