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
        case let pathMark as PathMark:
            context.fill(pathMark.path, with: .color(.yellow))
        case let tuple as TupleContent<Content>:
            Mirror(reflecting: tuple).children
                .forEach {
                    if let child = $0.value as? any WatchContent {
                        self.render(context: &context, rect: rect, content: child)
                    }
                }
        default:
            break
        }
    }
}

#Preview("test: multiple mark render") {
    Watchface {
        PathMark(Path(ellipseIn: .init(origin: .zero, size: .init(width: 400, height: 200))))
        PathMark(Path(ellipseIn: .init(origin: .zero, size: .init(width: 100, height: 200))))
        PathMark(Path(ellipseIn: .init(origin: .zero, size: .init(width: 100, height: 200))))
    }
}

#Preview("test: one mark styling") {
    Watchface {
        PathMark(Path(ellipseIn: .init(origin: .zero, size: .init(width: 100, height: 200))))
//            .style(with: .blue)
    }
}
