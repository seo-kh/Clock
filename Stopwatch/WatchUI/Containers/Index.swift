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
    init<D, R>(_ data: D, @WatchContentBuilder indexContent: @escaping (D.Element) -> R) where D: RandomAccessCollection, D.Element: Equatable, R: WatchContent, Content == AnyWatchContent {
        let total: CGFloat = CGFloat(data.count)
        let radians: CGFloat = 2.0 * CGFloat.pi / total
        let size: Size = .init(width: .equal(total: total))
        let indicies = 0..<data.count
        
        self.init(size: size, content: {
            AnyWatchContent {
                Loop(data: indicies) { index in
                    let angle: Angle = Angle.radians(radians * CGFloat(index))
                    let offset = data.index(data.startIndex, offsetBy: index)
                    return indexContent(data[offset]).axisRotation(angle: angle)
                }
            }
        })
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
            Index(0..<10, indexContent: { i in
                TextMark(anchor: .center) {
                    Text("\(i)")
                        .font(.largeTitle)
                }
            })
            .frame(width: 160, height: 160)
        }
    }
}

