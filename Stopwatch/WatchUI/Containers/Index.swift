//
//  Index.swift
//  WatchUI
//
//  Created by 테스트 on 2/19/26.
//

import SwiftUI

public struct Index<Content>: WatchContent where Content: WatchContent {
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

public extension Index {
    init<D, R>(_ data: D, @WatchContentBuilder rowContent: @escaping (D.Element) -> R) where D: RandomAccessCollection, D.Element: Equatable, R: WatchContent, Content == AnyWatchContent {
        let parts: CGFloat = CGFloat(data.count)
        let radians: CGFloat = 2.0 * CGFloat.pi / parts
        let size: Size = .init()
        let idxData: [(index: Int, body: D.Element)] = data.enumerated().map({ ($0, $1) })
        
        self.init(size: size, content: {
            AnyWatchContent {
                Loop(data: idxData) { element in
                    let angle: Angle = Angle.radians(radians * CGFloat(element.index))
                    return rowContent(element.body).axisRotation(angle: angle)
                }
            }
        })
    }
    
    init<Element: WatchContent>(@WatchContentBuilder content: @escaping () -> Element) where Content == AnyWatchContent {
        let _content = content()
        
        if let array = _content as? ArrayContent {
            let parts: CGFloat = CGFloat(array.count)
            let radians: CGFloat = 2.0 * CGFloat.pi / parts
            let size: Size = .init()
            
            self.init(size: size) {
                AnyWatchContent {
                    array
                        .map { element in
                            let angle: Angle = Angle.radians(radians * CGFloat(element.index))
                            return element.body.axisRotation(angle: angle)
                        }
                }
            }
        } else {
            let size: Size = .init()
            
            self.init(size: size, content: {
                    AnyWatchContent {
                        _content
                    }
                }
            )
        }
    }
}

#Preview("index face") {
    Watchface {
        Layer(anchor: .center) {
            Index(["30", "5", "10", "15", "20", "25"]) { sec in
                TextMark(anchor: .center) {
                    Text(sec)
                        .font(.system(size: 14))
                        .foregroundStyle(.white)
                }
            }
            .frame(width: 160, height: 160)
        }
    }
}

#Preview("loop") {
    Watchface {
        Layer(anchor: .center) {
            Index(0..<10, rowContent: { i in
                TextMark(anchor: .center) {
                    Text("\(i)")
                        .font(.largeTitle)
                }
            })
            .frame(width: 160, height: 160)
        }
    }
}

#Preview("builder") {
    Watchface {
        Layer(anchor: .center) {
            Index(content: {
                TextMark(anchor: .center) {
                    Text("60")
                        .font(.largeTitle)
                }
                TextMark(anchor: .center) {
                    Text("5")
                        .font(.largeTitle)
                }
                TextMark(anchor: .center) {
                    Text("10")
                        .font(.largeTitle)
                }
                TextMark(anchor: .center) {
                    Text("15")
                        .font(.largeTitle)
                }
            })
            .frame(width: 160, height: 160)
        }
    }
}

#Preview("single") {
    Watchface {
        Layer(anchor: .center) {
            Index(content: {
                TextMark(anchor: .center) {
                    Text("60")
                        .font(.largeTitle)
                }
            })
            .frame(width: 160, height: 160)
        }
    }
}

