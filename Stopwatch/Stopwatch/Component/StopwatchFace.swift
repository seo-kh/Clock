//
//  StopwatchFace.swift
//  Stopwatch
//
//  Created by alphacircle on 1/9/26.
//

import SwiftUI
import WatchUI

/// 시계화면 UI
///
/// [용어의 정리]
/// 1. Hand: 시침, 분침, 초침 같은 시곗바늘
/// 2. Index: 시각을 표시하는 숫자, 기호
/// 3. Scale: Index 사이의 작은 눈금표시
/// 4. Window: 날짜나 기타 정보를 표시하는 창
/// 5. Face: 1~4의 모든 요소를 포함하는 전체
///
/// 참고링크: [알아 두면 도움 되는 시계 용어](https://magazine.hankyung.com/money/article/202101206538c)
struct StopwatchFace: View {
    let total: TimeInterval
    let split: TimeInterval
    
    init(total: TimeInterval, split: TimeInterval) {
        self.total = total
        self.split = split
    }
    
    init(lap: Lap) {
        self.total = lap.progress - lap.total
        self.split = lap.progress - lap.split
    }
    
    var body: some View {
        Canvas { context, size in
            context.drawLayer { scaleCtx in
                scale(&scaleCtx, size)
            }
            
            context.drawLayer { indexCtx in
                index(&indexCtx, size)
            }
            
            context.drawLayer { minScaleCtx in
                minScale(&minScaleCtx, size)
            }
            
            context.drawLayer { minIndexCtx in
                minIndex(&minIndexCtx, size)
            }
            
            context.drawLayer { minHandCtx in
                minHand(&minHandCtx, size, timeInterval: total, color: CKColor.orange)
            }
            
            context.drawLayer { minCenterCtx in
                minCenter(&minCenterCtx, size)
            }
            
            context.drawLayer { timeWindowCtx in
                timeWindow(&timeWindowCtx, size, timeInterval: total)
            }
            
            context.drawLayer { splitHandCtx in
                hand(&splitHandCtx, size, timeInterval: split, color: CKColor.blue)
            }
            
            context.drawLayer { totalHandCtx in
                hand(&totalHandCtx, size, timeInterval: total, color: CKColor.orange)
            }
            
            context.drawLayer { centerCtx in
                center(&centerCtx, size)
            }
        }
    }
    
    private func minCenter(_ context: inout GraphicsContext, _ size: CGSize) {
        let radius = min(size.height, size.width) / 2.0
        
        context.translateBy(x: radius, y: radius * 0.65)
        
        let pivot: CGFloat = 6.0
        let outer = CGRect(origin: CGPoint(x: -pivot / 2.0, y: -pivot / 2.0), size: CGSize(width: pivot, height: pivot))
        context.fill(Circle().path(in: outer), with: .color(CKColor.orange))
    }
    
    private func center(_ context: inout GraphicsContext, _ size: CGSize) {
        let radius = min(size.height, size.width) / 2.0
        
        context.translateBy(x: radius, y: radius)
        
        let pivot: CGFloat = 8.0
        let outer = CGRect(origin: CGPoint(x: -pivot / 2.0, y: -pivot / 2.0), size: CGSize(width: pivot, height: pivot))
        let inner = outer.applying(.init(scaleX: 0.5, y: 0.5))
        context.fill(Circle().path(in: outer), with: .color(CKColor.orange))
        context.fill(Circle().path(in: inner), with: .color(CKColor.background))
    }
    
    private func hand(_ context: inout GraphicsContext, _ size: CGSize, timeInterval: TimeInterval, color: Color) {
        let radius = min(size.height, size.width) / 2.0
        let radian = 2.0 * CGFloat.pi / 60.0 * timeInterval
        
        context.translateBy(x: radius, y: radius)
        let scaleWidth = 2.0 * CGFloat.pi * radius / 480.0
        let scalePoint = CGPoint(x: -scaleWidth / 2.0, y: -radius)
        let scaleSize = CGSize(width: scaleWidth, height: radius * 1.2)
        let scaleRect = CGRect(origin: scalePoint, size: scaleSize)
        let angle = Angle(radians: radian)
        context.rotate(by: angle)
        context.fill(Rectangle().path(in: scaleRect), with: .color(color))
    }
    
    private func minHand(_ context: inout GraphicsContext, _ size: CGSize, timeInterval: TimeInterval, color: Color) {
        let radius = min(size.height, size.width) / 2.0
        let radian = 2.0 * CGFloat.pi / 60.0 / 30.0 * timeInterval
        
        context.translateBy(x: radius, y: radius * 0.65)
        let scaleWidth = 2.0 * CGFloat.pi * radius * 0.3 / 180.0
        let scalePoint = CGPoint(x: -scaleWidth / 2.0, y: -radius * 0.275)
        let scaleSize = CGSize(width: scaleWidth, height: radius * 0.275)
        let scaleRect = CGRect(origin: scalePoint, size: scaleSize)
        let angle = Angle(radians: radian)
        context.rotate(by: angle)
        context.fill(Rectangle().path(in: scaleRect), with: .color(color))
    }
    
    private func timeWindow(_ context: inout GraphicsContext, _ size: CGSize, timeInterval: TimeInterval) {
        let radius = min(size.height, size.width) / 2.0
        
        context.translateBy(x: radius, y: radius)
        
        let now = Date()
        let elap = now.addingTimeInterval(timeInterval)
        let text = SystemFormatStyle.Stopwatch(startingAt: now).format(elap)
        let sec = Text(text).font(.system(size: 24)).foregroundStyle(CKColor.label).tracking(2.0)
        let position = CGPoint(x: 0, y: radius * 0.35)
        context.draw(sec, at: position, anchor: .center)
    }
    
    private func index(_ context: inout GraphicsContext, _ size: CGSize) {
        let radius = min(size.height, size.width) / 2.0
        
        context.translateBy(x: radius, y: radius)
        for i in 0..<12 {
            let text = (i != 0) ? "\(i * 5)" : "60"
            let sec = Text(text).font(.system(size: 28)).foregroundStyle(CKColor.label)
            let position = CGPoint(x: 0, y: -radius * 0.80)
                .applying(.init(rotationAngle: Angle(degrees: Double(i * 30)).radians))
            context.draw(sec, at: position, anchor: .center)
        }
    }
    
    private func scale(_ context: inout GraphicsContext, _ size: CGSize, count: Int, span: Int, aspectRatio: CGFloat) {
        let radius = min(size.height, size.width) / 2.0
        let _count = CGFloat(count)
        let _total = _count * CGFloat(span + 1)
        let scaleWidth = 2.0 * CGFloat.pi * radius / _total
        
        let scalePoint = CGPoint(x: -scaleWidth / 2.0, y: -radius)
        let scaleSize = CGSize(width: scaleWidth, height: scaleWidth * aspectRatio)
        let scaleRect = CGRect(origin: scalePoint, size: scaleSize)
        let unitDegree = 360.0 / _count
        
        context.translateBy(x: radius, y: radius)
        
        for _ in stride(from: 0.0, to: _total, by: 1.0) {
            context.fill(Rectangle().path(in: scaleRect), with: .color(CKColor.gray5))
            let angle = Angle(degrees: unitDegree)
            context.rotate(by: angle)
        }
    }
    
    private func minIndex(_ context: inout GraphicsContext, _ size: CGSize) {
        let radius = min(size.height, size.width) / 2.0
        
        context.translateBy(x: radius, y: radius * 0.65)
        for i in 0..<6 {
            let text = (i != 0) ? "\(i * 5)" : "30"
            let sec = Text(text).font(.system(size: 14)).foregroundStyle(CKColor.label)
            let position = CGPoint(x: 0, y: -radius * 0.15)
                .applying(.init(rotationAngle: Angle(degrees: Double(i * 60)).radians))
            context.draw(sec, at: position, anchor: .center)
        }
    }
    
    private func minScale(_ context: inout GraphicsContext, _ size: CGSize) {
        let radius = min(size.height, size.width) / 2.0
        let scaleWidth = 2.0 * CGFloat.pi * radius * 0.3 / 180.0
        
        let scalePoint = CGPoint(x: -scaleWidth / 2.0, y: -radius * 0.275)
        let qScaleSize = CGSize(width: scaleWidth, height: scaleWidth * 3.0)
        let qScaleRect = CGRect(origin: scalePoint, size: qScaleSize)
        let sScaleSize = CGSize(width: scaleWidth, height: scaleWidth * 6.0)
        let sScaleRect = CGRect(origin: scalePoint, size: sScaleSize)
        
        context.translateBy(x: radius, y: radius * 0.65)
        
        for _ in 0..<60 {
            context.fill(Rectangle().path(in: qScaleRect), with: .color(CKColor.gray5))
            let angle = Angle(degrees: 6.0)
            context.rotate(by: angle)
        }
        
        for _ in 0..<30 {
            context.fill(Rectangle().path(in: sScaleRect), with: .color(CKColor.gray5))
            let angle = Angle(degrees: 12.0)
            context.rotate(by: angle)
        }
        
        for _ in 0..<6 {
            context.fill(Rectangle().path(in: sScaleRect), with: .color(CKColor.label))
            let angle = Angle(degrees: 60.0)
            context.rotate(by: angle)
        }
    }
    
    private func scale(rect: CGRect, total: Int, span: Int = 1, aspectRatio: CGFloat = 1.0 / 1.0) {
        let radius = min(rect.height, rect.width) / 2.0
        let scaleWidth = 2.0 * CGFloat.pi * radius / CGFloat(total * span)
        
        let scalePoint = CGPoint(x: -scaleWidth / 2.0, y: -radius)
        let scaleSize = CGSize(width: scaleWidth, height: scaleWidth / aspectRatio)
        let scaleRect = CGRect(origin: scalePoint, size: scaleSize)
    }
    
    private func loop<Data>(_ context: inout GraphicsContext,
                            rect: CGRect,
                            data: Data,
                            render: ((Data.Element) -> Void)? = nil
    ) where Data: RandomAccessCollection, Data.Element: Hashable {
        for ele in data {
            render?(ele)
        }
    }

    private func rotate(_ context: inout GraphicsContext,
                        angle: Angle,
                        render: (() -> Void)? = nil
    ) {
        render?()
        context.rotate(by: angle)
    }

    private func shape(_ context: inout GraphicsContext,
                       rect: CGRect,
                       shape: some Shape,
                       shading: GraphicsContext.Shading
    ) {
        context.fill(shape.path(in: rect), with: shading)
    }

    private func scale(_ context: inout GraphicsContext, _ size: CGSize) {
        let radius = min(size.height, size.width) / 2.0
        let scaleWidth = 2.0 * CGFloat.pi * radius / 480.0
        
        let scalePoint = CGPoint(x: -scaleWidth / 2.0, y: -radius)
        let qScaleSize = CGSize(width: scaleWidth, height: scaleWidth * 3.0)
        let qScaleRect = CGRect(origin: scalePoint, size: qScaleSize)
        let sScaleSize = CGSize(width: scaleWidth, height: scaleWidth * 6.0)
        let sScaleRect = CGRect(origin: scalePoint, size: sScaleSize)
        
        context.translateBy(x: radius, y: radius)
        
        for _ in 0..<240 {
            context.fill(Rectangle().path(in: qScaleRect), with: .color(CKColor.gray5))
            let angle = Angle(degrees: 1.5)
            context.rotate(by: angle)
        }
        
        for _ in 0..<60 {
            context.fill(Rectangle().path(in: sScaleRect), with: .color(CKColor.gray5))
            let angle = Angle(degrees: 6.0)
            context.rotate(by: angle)
        }
        
        for _ in 0..<12 {
            context.fill(Rectangle().path(in: sScaleRect), with: .color(CKColor.label))
            let angle = Angle(degrees: 30.0)
            context.rotate(by: angle)
        }
    }
}

private struct TestStopwatch: View {
    let now = Date.now
    
    var body: some View {
        TimelineView(.periodic(from: now, by: 0.03)) { ctx in
            StopwatchFace(total: ctx.date - now + 11.0, split: ctx.date - now)
        }
    }
}

#Preview("Stateful") {
    TestStopwatch()
        .frame(width: 500, height: 500)
        .padding()
        .background(CKColor.background)
}

#Preview("First Lap: 30[s]") {
    StopwatchFace(total: 30.0, split: 30.0)
        .frame(width: 500, height: 500)
        .padding()
        .background(CKColor.background)
}

#Preview("progress..") {
    StopwatchFace(total: 555.0, split: 20.0) // total: 9m 15s, split: 20 [sec]
        .frame(width: 500, height: 500)
        .padding()
        .background(CKColor.background)
}

// ---------------------------- Stopwatch DSL --------------------------

struct _StopwatchFace: View {
    let contents: [StopwatchContent]
    
    init(@StopwatchContentBuilder _ content: () -> [any StopwatchContent]) {
        self.contents = content()
    }
    
    var body: some View {
        Canvas { ctx, size in
            let rect = CGRect(origin: CGPoint.zero, size: size)
            
            for content in contents {
                content
                    .bound(rect)
                    .draw(&ctx)
            }
        }
    }
    
}

#Preview {
    _StopwatchFace {
        Layer(alignment: .center) {
            // 1
            Scale(total: 240, span: 2) {
                Mark(kind: .shape(Rectangle()))
                    .style(with: .color(CKColor.gray5))
            }
            .aspectRatio(1.0 / 3.0)
            
            // 2
            Scale(total: 60, span: 8) {
                Mark(kind: .shape(Rectangle()))
                    .style(with: .color(CKColor.gray5))
            }
            .aspectRatio(1.0 / 6.0)
            
            // 3
            Scale(total: 12, span: 40) {
                Mark(kind: .shape(Rectangle()))
                    .style(with: .color(CKColor.label))
            }
            .aspectRatio(1.0 / 6.0)
        }
        
        Layer(alignment: .center) {
            Scale(total: 60, span: 3) {
                Mark(kind: .shape(Rectangle()))
                    .style(with: .color(CKColor.gray5))
            }
            .aspectRatio(1.0 / 3.0)
            
            Scale(total: 30, span: 6) {
                Mark(kind: .shape(Rectangle()))
                    .style(with: .color(CKColor.gray5))
            }
            .aspectRatio(1.0 / 6.0)
            
            Scale(total: 6, span: 30) {
                Mark(kind: .shape(Rectangle()))
                    .style(with: .color(CKColor.label))
            }
            .aspectRatio(1.0 / 6.0)
        }
        .frame(width: 138, height: 138)
        .offset(y: -86)
    }
    .frame(width: 500, height: 500)
    .padding()
    .background(CKColor.background)
}
