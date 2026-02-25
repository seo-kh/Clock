//
//  Scale.swift
//  WatchUI
//
//  Created by alphacircle on 2/19/26.
//

import SwiftUI

public struct Scale<Content: WatchContent>: WatchContent {
    let size: Size
    let content: () -> Content
    
    init(size: Size, content: @escaping () -> Content) {
        self.size = size
        self.content = content
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        let length: CGFloat = min(rect.width, rect.height)
        let radius: CGFloat = length / 2.0
        let newRect: CGRect = size.makeCGRect(length: radius)

        content()
            .render(&context, rect: newRect)
    }
}

public extension Scale {
    init<D, R>(_ data: D, span: Int = 1, @WatchContentBuilder rowContent: @escaping (D.Element) -> R) where D: RandomAccessCollection, D.Element: Equatable, R: WatchContent, Content == AnyWatchContent {
        let parts: CGFloat = CGFloat(data.count)
        let size: Size = .init(width: .equal(parts: parts, span: CGFloat(span)))
        self.init(size: size, content: {
            AnyWatchContent {
                Loop(data: data) { element in
                    let isFirst: Bool = (data.first == element)
                    return rowContent(element)
                        .coordinateRotation(angle: isFirst ? .degrees(0.0) : .degrees(360.0 / parts))
                }
            }
        })
    }
    
    init<Element: WatchContent>(span: Int = 1, @WatchContentBuilder content: @escaping () -> Element) where Content == AnyWatchContent {
        let _content = content()
        
        if let array = _content as? ArrayContent {
            let parts: CGFloat = CGFloat(array.count)
            let size: Size = .init(width: .equal(parts: parts, span: CGFloat(span)))
            self.init(size: size) {
                AnyWatchContent {
                    array
                        .map { element in
                            let isFirst: Bool = (array.contents.first?.index == element.index)
                            let angle: Angle = isFirst ? .degrees(0.0) : .degrees(360.0 / parts)
                            return element.body.coordinateRotation(angle: angle)
                        }
                }
            }
        } else {
            let size: Size = .init(width: .equal(parts: CGFloat(span)))
            self.init(size: size, content: {
                    AnyWatchContent {
                        _content
                    }
                }
            )
        }
    }
}

#Preview("new api - plain") {
    Watchface {
        Layer(anchor: .center) {
            Scale(span: 5) {
                ShapeMark(Rectangle(), anchor: .top)
                    .style(with: .color(.red))

                ShapeMark(Rectangle(), anchor: .top)
                    .style(with: .color(.green))

                ShapeMark(Rectangle(), anchor: .top)
                    .style(with: .color(.blue))
            }
        }
    }
}

#Preview("new api - loop") {
    Watchface {
        Layer(anchor: .center) {
            Scale(0..<3, span: 5) { i in
                ShapeMark(Rectangle(), anchor: .top)
                    .style(with: .color(.red))
            }
        }
    }
}

#Preview("equal width") {
    let width: SizeRule = .equal(parts: 60, span: 3)
    let height: SizeRule = .identity
    let y: SizeRule = .identity
    
    Watchface {
        Layer(anchor: .center) {
            Scale(size: .init(y: y, width: width, height: height)) {
                Loop(data: 0..<60) { _ in
                    ShapeMark(Rectangle(), anchor: .top)
                        .style(with: .color(.red))
                        .coordinateRotation(angle: .degrees(360.0 / 60))
                }
            }
        }
    }
}

#Preview("fixed height") {
    let width: SizeRule = .equal(parts: 60, span: 3)
    let height: SizeRule = .fixed(10)
    let y: SizeRule = .identity
    
    Watchface {
        Layer(anchor: .center) {
            Scale(size: .init(y: y, width: width, height: height)) {
                Loop(data: 0..<60) { _ in
                    ShapeMark(Rectangle(), anchor: .top)
                        .style(with: .color(.red))
                        .coordinateRotation(angle: .degrees(360.0 / 60))
                }
            }
        }
    }
}

#Preview("fixed position") {
    let width: SizeRule = .equal(parts: 60, span: 3)
    let height: SizeRule = .fixed(10)
    let y: SizeRule = .fixed(100)
    
    Watchface {
        Layer(anchor: .center) {
            Scale(size: .init(y: y, width: width, height: height)) {
                Loop(data: 0..<60) { _ in
                    ShapeMark(Rectangle(), anchor: .top)
                        .style(with: .color(.red))
                        .coordinateRotation(angle: .degrees(360.0 / 60))
                }
            }
        }
    }
}
