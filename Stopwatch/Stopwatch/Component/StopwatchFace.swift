//
//  StopwatchFace.swift
//  Stopwatch
//
//  Created by alphacircle on 1/9/26.
//

import SwiftUI

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


/**
 
 New StopwatchFace API (DSL)
 
 -> StopwatchContent => context
 -> StopwatchContentBuilder =>
 
 StopwatchFace {
 Layer {
 Scale() *note* : what to show, where to place
 Scale()
 Scale()
 }
 
 Layer {
 Index()
 }
 }
 */

struct _StopwatchFace: View {
    let contents: [StopwatchContent]
    
    init(@StopwatchContentBuilder _ content: () -> [StopwatchContent]) {
        self.contents = content()
    }
    
    var body: some View {
        Canvas { ctx, size in
            for content in contents {
                content
                    .bound(size)
                    .draw(&ctx)
            }
        }
    }
    
}

protocol StopwatchContent {
    func draw(_ context: inout GraphicsContext)
    func bound(_ size: CGSize) -> StopwatchContent
}

@resultBuilder
enum StopwatchContentBuilder {
    static func buildBlock(_ components: StopwatchContent...) -> [StopwatchContent] {
        components
    }
}

struct Layer: StopwatchContent {
    private let rect: CGRect
    private let contents: [StopwatchContent]
    private let alignment: Alignment
    private let offset: CGSize
    
    enum Alignment {
        case topLeading
        case center
        case bottomTrailing
    }
    
    private init(rect: CGRect, contents: [StopwatchContent], alignment: Alignment, offset: CGSize) {
        self.rect = rect
        self.contents = contents
        self.alignment = alignment
        self.offset = offset
    }
    
    init(alignment: Alignment? = nil, offset: CGSize? = nil, @StopwatchContentBuilder _ content: () -> [StopwatchContent]) {
        self.init(rect: .zero,
                  contents: content(),
                  alignment: alignment ?? .topLeading,
                  offset: offset ?? .zero)
        
    }
    
    func draw(_ context: inout GraphicsContext) {
        context.drawLayer { ctx in
            ctx.translateBy(x: rect.minX, y: rect.minY)
            
            for content in contents {
                content
                    .bound(rect.size)
                    .draw(&ctx)
            }
        }
    }
    
    func bound(_ size: CGSize) -> StopwatchContent {
        let alignedPoint: CGPoint
        switch alignment {
        case .topLeading:
            alignedPoint = .zero
        case .center:
            alignedPoint = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        case .bottomTrailing:
            alignedPoint = CGPoint(x: size.width, y: size.height)
        }
        
        let offsetPoint: CGPoint = alignedPoint.applying(.init(translationX: offset.width, y: offset.height))
        let transforRect = CGRect(origin: offsetPoint, size: size)
        
        return Self(rect: transforRect, contents: contents, alignment: alignment, offset: offset)
    }
}

struct ScaleTick: StopwatchContent {
    private var path: Path
    private var shading: GraphicsContext.Shading
    
    private init(path: Path, shading: GraphicsContext.Shading) {
        self.path = path
        self.shading = shading
    }
    
    init(path: Path) {
        let rect = path.boundingRect
        let trans = CGAffineTransform(translationX: -(rect.width / 2.0), y: .zero)
        let newPath = path.applying(trans)
        self.init(path: newPath, shading: .color(.black))
    }
    
    init(_ callback: (inout Path) -> Void) {
        self.init(path: Path(callback))
    }
    
    init(shape: any Shape, rect: CGRect) {
        self.init(path: shape.path(in: rect))
    }
    
    init(shape: any Shape, origin: CGPoint, size: CGSize) {
        let rect = CGRect(origin: origin, size: size)
        self.init(path: shape.path(in: rect))
    }

    func bound(_ size: CGSize) -> StopwatchContent {
        self
    }

    func style(with shading: GraphicsContext.Shading) -> Self {
        Self(path: self.path, shading: shading)
    }
    
    func draw(_ context: inout GraphicsContext) {
        context.fill(path, with: shading)
    }
}

struct Scale: StopwatchContent {
    private let tick: ScaleTick
    private let total: Int
    private let span: Int
    private let aspectRatio: CGFloat
    
    private init(tick: ScaleTick, total: Int, span: Int, aspectRatio: CGFloat) {
        self.tick = tick
        self.total = total
        self.span = span
        self.aspectRatio = aspectRatio
    }
    
    init(total: Int, span: Int = 0, aspectRatio: CGFloat = 1.0 / 1.0) {
        let tick = ScaleTick(shape: Rectangle(), rect: .zero)
        self.init(tick: tick, total: total, span: span, aspectRatio: aspectRatio)
    }
    
    func bound(_ size: CGSize) -> any StopwatchContent {
        let radius = min(size.height, size.width) / 2.0
        
        // tick spec
        let tickWidth = 2.0 * CGFloat.pi * radius / Double(total * (span + 1))
        let tickHeight = tickWidth / aspectRatio
        let tickSize = CGSize(width: tickWidth, height: tickHeight)
        let tickPoint = CGPoint(x: 0, y: -radius)
        let tickRect = CGRect(origin: tickPoint, size: tickSize)
        // tick
        let tick = ScaleTick(shape: Rectangle(), rect: tickRect)
        // new init
        return Self(tick: tick, total: total, span: span, aspectRatio: aspectRatio)
    }
    
    func draw(_ context: inout GraphicsContext) {
        for _ in 0..<total {
            tick.draw(&context)
            let degree = Angle.degrees(360.0 / Double(total))
            context.rotate(by: degree)
        }
    }
}

#Preview {
    _StopwatchFace {
        Layer(alignment: .center, offset: .init(width: 0, height: 0)) {
            Scale(total: 240, span: 1, aspectRatio: 1.0 / 3.0)
        }
    }
    .frame(width: 500, height: 500)
}
