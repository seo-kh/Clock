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
    
    public init(size: Size, content: @escaping () -> Content) {
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

public extension Scale where Content == AnyWatchContent {
    init<R>(_ interval: Range<Int>, times: Int = 1, period: Int = 1, @WatchContentBuilder scaleContent: @escaping (Tick) -> R) where R: WatchContent {
        // tick의 사이즈 계산
        let _times = max(1, times)
        let _period = max(1, period)
        let _count = interval.count
        let tickCount = _count * _times
        let total = tickCount * _period
        let size: Size = Size(width: .equal(total: CGFloat(total)))
        
        // tick의 base, offset, delta, angle 계산 및 적용
        let offsetInterval = 0..<_times
        let delta = 1.0 / TimeInterval(_times)
        let angle = Angle(degrees: 360.0 / CGFloat(tickCount))
        
        self.init(size: size, content: {
            AnyWatchContent {
                Loop(data: interval) { base in
                    Loop(data: offsetInterval) { offset in
                        let tick = Tick(base: base, offset: offset, delta: delta)
                        
                        scaleContent(tick)
                            .coordinateRotation(angle: tick.isOrigin ? Angle.zero : angle)
                    }
                }
            }
        })
    }
}

#Preview("scale demo 1") {
    Watchface {
        Layer(anchor: .center) {
            Scale(0..<6, times: 4, period: 2) { tick in
                ShapeMark(Circle(), anchor: .center)
                    .style(with: .color(Color(hue: tick.mark / 6.0, saturation: 1.0, brightness: 1.0)))
                    .aspectRatio(1.0)
                    .scale(tick.isBase ? 1.2 : 0.7)
            }
            .scale(0.9)
        }
    }
}

#Preview("scale demo 2") {
    Watchface {
        Layer(anchor: .center) {
            Scale(0..<6, times: 4, period: 2) { tick in
                ShapeMark(Rectangle(), anchor: .top)
                    .style(with: .color(tick.mark < 3.0 ? .red : .blue))
                    .aspectRatio(tick.isBase ? 1.0 / 3.0 : 1.0 / 1.5)
            }
        }
    }
}

#Preview("equal width") {
    let width: SizeRule = .equal(total: 180)
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
    let width: SizeRule = .equal(total: 180)
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
    let width: SizeRule = .equal(total: 180)
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
