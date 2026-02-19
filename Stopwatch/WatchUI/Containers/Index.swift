//
//  Index.swift
//  WatchUI
//
//  Created by 테스트 on 2/19/26.
//

import SwiftUI

public struct Index<Data, Content>: WatchContent where Content: WatchContent, Data: RandomAccessCollection, Data.Element: Hashable {
    let data: Data
    let content: (Data.Element) -> Content
    
    public init(_ data: Data, content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
    }
    
    private func align(from src: CGRect) -> CGPoint {
        let radius = min(src.size.height, src.size.width) / 2.0
        let position = CGPoint(x: 0, y: -radius)
        return position
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        let radians: CGFloat = 2.0 * CGFloat.pi / CGFloat(data.count)
        let radius = min(rect.size.height, rect.size.width) / 2.0
        let position = CGPoint(x: 0, y: -radius)

        for (idx, ele) in data.enumerated() {
            
            let angle: Angle = Angle(radians: radians * CGFloat(idx))
            let transform = CGAffineTransform(rotationAngle: angle.radians)
            let newRect: CGRect = CGRect(origin: position.applying(transform), size: rect.size)
            content(ele)
                .render(&context, rect: newRect)
        }
    }
}

#Preview {
    Watchface {
        Layer(alignment: .center) {
            Index(0..<12) { i in
                TextMark(anchor: .center) {
                    let text = (i != 0) ? "\(i * 5)" : "60"
                    let sec = Text(text).font(.system(size: 28)).foregroundStyle(.white)
                    return sec
                }
            }
            .frame(width: 160, height: 160)
        }
    }
}
