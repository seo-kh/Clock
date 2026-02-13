//
//  Watchface.swift
//  WatchUI
//
//  Created by alphacircle on 2/6/26.
//

import SwiftUI

public struct Watchface<Content: WatchContent>: View {
    let content: () -> Content
    
    public init(@WatchContentBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        Canvas { (context, size) in
            let rect = CGRect(origin: CGPoint.zero, size: size)
            render(context: &context, rect: rect, content: content())
        }
    }
    
    private func render(context: inout GraphicsContext, rect: CGRect, content: some WatchContent) {
        switch content {
        case let mark as TextMark:
            renderText(context: &context, rect: rect, text: mark.value)
        default:
            renderTuple(context: &context, rect: rect, content: content)
        }
    }
    
    private func renderText(context: inout GraphicsContext, rect: CGRect, text: Text) {
        context.draw(text, in: rect)
    }
    
    private func renderTuple(context: inout GraphicsContext, rect: CGRect, content: some WatchContent) {
        
    }
}

#Preview("test: layer mark render") {
    Watchface {
        Layer(alignment: .center) {
            TextMark("layer test")
        }
    }
}

#Preview("test: multiple mark render") {
    Watchface {
        TextMark("text 1")
        TextMark("text 2")
        TextMark("text 3")
    }
}

#Preview("test: one mark styling") {
    Watchface {
        TextMark("text")
    }
}
