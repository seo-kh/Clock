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
    var body: some View {
        Canvas { context, size in
            context.drawLayer { scaleCtx in
                scale(&scaleCtx, size)
            }

            context.drawLayer { indexCtx in
                index(&indexCtx, size)
            }
            
            context.drawLayer { timeWindowCtx in
                timeWindow(&timeWindowCtx, size)
            }
            
            context.drawLayer { splitHandCtx in
                hand(&splitHandCtx, size, timeInterval: 100.0, color: CKColor.blue)
            }
            
            context.drawLayer { totalHandCtx in
                hand(&totalHandCtx, size, timeInterval: 200.0, color: CKColor.orange)
            }
            
            context.drawLayer { centerCtx in
                center(&centerCtx, size)
            }
        }
    }
    
    private func center(_ context: inout GraphicsContext, _ size: CGSize) {
        let radius = min(size.height, size.width) / 2.0
        
        context.translateBy(x: radius, y: radius)

        let pivot: CGFloat = 16.0
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

    private func timeWindow(_ context: inout GraphicsContext, _ size: CGSize) {
        let radius = min(size.height, size.width) / 2.0
        
        context.translateBy(x: radius, y: radius)
        
        let text = "06:24.69"
        let sec = Text(text).font(.system(size: 32)).foregroundStyle(CKColor.label).tracking(2.0)
        let position = CGPoint(x: 0, y: radius * 0.35)
        context.draw(sec, at: position, anchor: .center)
    }

    private func index(_ context: inout GraphicsContext, _ size: CGSize) {
        let radius = min(size.height, size.width) / 2.0
        
        context.translateBy(x: radius, y: radius)
        for i in 0..<12 {
            let text = (i != 0) ? "\(i * 5)" : "60"
            let sec = Text(text).font(.system(size: 42)).foregroundStyle(CKColor.label)
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

    private func scale(_ context: inout GraphicsContext, _ size: CGSize) {
        let radius = min(size.height, size.width) / 2.0
        let scaleWidth = 2.0 * CGFloat.pi * radius / 480.0
        
        let scalePoint = CGPoint(x: -scaleWidth / 2.0, y: -radius)
        let qScaleSize = CGSize(width: scaleWidth, height: scaleWidth * 3.0)
        let qScaleRect = CGRect(origin: scalePoint, size: qScaleSize)
        let sScaleSize = CGSize(width: scaleWidth, height: scaleWidth * 6.0)
        let sScaleRect = CGRect(origin: scalePoint, size: sScaleSize)

        context.translateBy(x: radius, y: radius)
        
        for _ in 0..<480 {
            context.fill(Rectangle().path(in: qScaleRect), with: .color(CKColor.gray5))
            let angle = Angle(degrees: 1.5)
            context.rotate(by: angle)
        }
        
        for _ in 0..<120 {
            context.fill(Rectangle().path(in: sScaleRect), with: .color(CKColor.gray5))
            let angle = Angle(degrees: 6.0)
            context.rotate(by: angle)
        }
        
        for _ in 0..<24 {
            context.fill(Rectangle().path(in: sScaleRect), with: .color(CKColor.label))
            let angle = Angle(degrees: 30.0)
            context.rotate(by: angle)
        }
    }
}

#Preview {
    StopwatchFace()
        .frame(width: 500, height: 500)
        .padding()
        .background(CKColor.background)
}
