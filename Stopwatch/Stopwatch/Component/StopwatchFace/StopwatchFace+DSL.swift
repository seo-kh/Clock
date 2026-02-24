//
//  StopwatchFace+DSL.swift
//  Stopwatch
//
//  Created by alphacircle on 2/24/26.
//

import SwiftUI
import WatchUI

extension StopwatchFace {
    struct DSL: View {
        let total: TimeInterval
        let split: TimeInterval
        
        init(total: TimeInterval, split: TimeInterval) {
            self.total = total
            self.split = split
        }
        
        var body: some View {
            Watchface {
                minuteLayer()
                
                secondsLayer()
                
                windowLayer()
            }
        }
    }
}

/// UI Components
private extension StopwatchFace.DSL {
    @WatchContentBuilder
    func windowLayer() -> some WatchContent {
        // Time window
        Layer(alignment: .center) {
            TextMark(anchor: .center) {
                Text(totalTimeFormat)
                    .font(.system(size: 24))
                    .foregroundStyle(CKColor.label)
                    .tracking(2.0)
            }
        }
        .offset(y: 30)
    }

    @WatchContentBuilder
    func secondsLayer() -> some WatchContent {
        // Seconds Scale
        Layer(alignment: .center) {
            Scale(0..<240, span: 2) { i in
                ShapeMark(Rectangle(), anchor: .top)
                    .style(with: .color(i.isMultiple(of: 20) ? CKColor.label : CKColor.gray5))
                    .aspectRatio(i.isMultiple(of: 4) ? 1.0 / 6.0 : 1.0 / 3.0)
            }
        }
            
        // Seconds Index
        Layer(alignment: .center) {
            Index(seconds) { second in
                TextMark(anchor: .center) {
                    Text(second)
                        .font(.system(size: 28))
                        .foregroundStyle(CKColor.label)
                }
            }
            .scale(0.8)
        }
        
        // Lap Hand
        Layer(alignment: .center) {
            Hand(size: .init(width: .equal(parts: 480), height: .propotional(1.1))) {
                ShapeMark(Rectangle(), anchor: .top)
                    .style(with: .color(CKColor.blue))
            }
            .coordinateRotation(angle: .radians(splitSecondRev))
        }
        
        // Seconds Hand
        Layer(alignment: .center) {
            Hand(size: .init(width: .equal(parts: 480), height: .propotional(1.1))) {
                ShapeMark(Rectangle(), anchor: .top)
                    .style(with: .color(CKColor.orange))
            }
            .coordinateRotation(angle: .radians(totalSecondRev))
        }

        // Seconds Hand Center
        Layer(alignment: .center) {
            ShapeMark(Circle(), anchor: .center)
                .style(with: .color(CKColor.orange))
                .frame(width: 8, height: 8)
            
            ShapeMark(Circle(), anchor: .center)
                .style(with: .color(CKColor.background))
                .frame(width: 4, height: 4)
        }
    }
    
    @WatchContentBuilder
    func minuteLayer() -> some WatchContent {
        // Minute Scale
        Layer(alignment: .center) {
            Scale(0..<60, span: 3) { i in
                ShapeMark(Rectangle(), anchor: .top)
                    .style(with: .color(i.isMultiple(of: 10) ? CKColor.label : CKColor.gray5))
                    .aspectRatio(i.isMultiple(of: 2) ? 1.0 / 6.0 : 1.0 / 3.0)
            }
            .scale(0.30)
        }
        .offset(y: -75)

        // Minute Index
        Layer(alignment: .center) {
            Index(minutes) { minute in
                TextMark(anchor: .center) {
                    Text(minute)
                        .font(.system(size: 14))
                        .foregroundStyle(CKColor.label)
                }
            }
            .scale(0.15)
        }
        .offset(y: -75)
        
        // Minute Hand
        Layer(alignment: .center) {
            Hand(size: .init(width: .equal(parts: 180))) {
                ShapeMark(Rectangle(), anchor: .top)
                    .style(with: .color(CKColor.orange))
                    .coordinateRotation(angle: .radians(totalMinuteRev))
            }
            .scale(0.30)
        }
        .offset(y: -75)

        // Minute Hand Center
        Layer(alignment: .center) {
            ShapeMark(Circle(), anchor: .center)
                .style(with: .color(CKColor.orange))
                .frame(width: 6, height: 6)
                .offset(y: -75)
        }
    }
}

extension StopwatchFace.DSL {
    private var totalTimeFormat: AttributedString {
        let now = Date.now
        let elapsed = now.addingTimeInterval(total)
        return SystemFormatStyle.Stopwatch(startingAt: now)
            .format(elapsed)
    }
    
    /// revolution per a 30 minute
    ///
    /// 30분당 1회전수
    ///
    /// ```
    /// rp30m = 2π / 30 [rev/m]
    /// ```
    private var rp30m: CGFloat {
        (2.0 * CGFloat.pi) / (60.0 * 30.0)
    }
    
    /// 총 소요시간 회전량 [단위: rad]
    ///
    /// rp30m 기준으로 계산
    private var totalMinuteRev: CGFloat {
        rp30m * total
    }
    
    /// revolution per a minute
    ///
    /// 1분당 1회전수
    ///
    /// ```
    /// rpm = 2π / 1 [rev/m]
    /// ```
    private var rpm: CGFloat {
        (2.0 * CGFloat.pi) / (60.0)
    }
    
    /// 총 소요시간 회전량 [단위: rad]
    ///
    /// rpm 기준으로 계산
    private var totalSecondRev: CGFloat {
        rpm * total
    }

    /// 스플릿시간 회전량 [단위: rad]
    ///
    /// rpm 기준으로 계산
    private var splitSecondRev: CGFloat {
        rpm * split
    }

    /// 분침 표시
    private var minutes: [String] {
        ["30", "5", "10", "15", "20", "25"]
    }
    
    /// 초침 표시
    private var seconds: [String] {
        ["60", "5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55"]
    }
    
}

#Preview("watch face") {
    StopwatchFace.DSL(total: 340, split: 402)
        .frame(width: 370,height: 500)
        .padding()
}
