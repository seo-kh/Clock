//
//  Scale.swift
//  Stopwatch
//
//  Created by alphacircle on 2/3/26.
//

import SwiftUI

struct Scale<Content: StopwatchContent>: StopwatchContent {
    private var aspectRatio: CGFloat
    private let span: Int
    private var contents: [Content]
    
    init(span: Int = 1, @StopwatchContentBuilder _ content: () -> [Content]) {
        self.span = max(span, 1)
        self.contents = content()
        self.aspectRatio = 1.0 / 1.0
    }
    
    init<Data: RandomAccessCollection>(
        _ data: Data,
        span: Int,
        _ content: (Data.Element) -> Content
    ) {
        self.contents = data.map({ content($0) })
        self.span = max(span, 1)
        self.aspectRatio = 1.0 / 1.0
    }
    
    init(total: Int, span: Int = 1, _ content: @escaping () -> Content) {
        self.span = max(span, 1)
        self.aspectRatio = 1.0 / 1.0
        self.contents = Array(repeating: content(), count: total)
    }
    
    func draw(_ context: inout GraphicsContext) {
        // degree
        let total = contents.count
        let degree = Angle.degrees(360.0 / Double(total))
        
        for content in contents {
            content
                .draw(&context)

            // rotate
            context.rotate(by: degree)
        }
    }
    
    func bound(_ rect: CGRect) -> Self {
        let radius = min(rect.size.height, rect.size.width) / 2.0
        
        // content spec
        let total = contents.count
        let contentWidth = 2.0 * CGFloat.pi * radius / Double(total * span)
        let contentHeight = contentWidth / aspectRatio
        let contentSize = CGSize(width: contentWidth, height: contentHeight)
        let contentPoint = CGPoint(x: -contentWidth / 2.0, y: -radius)
        let contentRect = CGRect(origin: contentPoint, size: contentSize)
        
        // content
        let newContents = self.contents.map({ $0.bound(contentRect) })
        
        // assign
        var _self = self
        _self.contents = newContents
        return _self
    }
    
    func aspectRatio(_ aspectRatio: CGFloat) -> Self {
        var _self = self
        _self.aspectRatio = aspectRatio
        return _self
    }
}
