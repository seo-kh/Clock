//
//  Watchface.swift
//  WatchUI
//
//  Created by alphacircle on 2/6/26.
//

import SwiftUI

public struct Watchface<Content: WatchContent>: View {
    private let content: () -> Content
    
    public init(@WatchContentBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        Canvas { (context, size) in
            let rect = CGRect(origin: CGPoint.zero, size: size)
            
//            if let tree = content() as? Renderable {
//                tree
//                    .render(context: &context, rect: rect)
//            }
        }
    }
    
    private func render(context: inout GraphicsContext, rect: CGRect) {
        
    }
}

#Preview("test: multiple mark render") {
    Watchface {
        PathMark(Path(ellipseIn: .init(origin: .zero, size: .zero)))
        PathMark(Path(ellipseIn: .init(origin: .zero, size: .zero)))
        PathMark(Path(ellipseIn: .init(origin: .zero, size: .zero)))
    }
}

#Preview("test: one mark styling") {
    Watchface {
        PathMark(Path(ellipseIn: .init(origin: .zero, size: .zero)))
//            .style(with: .blue)
    }
}
