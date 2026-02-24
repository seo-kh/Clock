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
    let engine: Engine
    
    enum Engine {
        case native
        case dsl
    }
    
    init(total: TimeInterval, split: TimeInterval, engine: Engine = .native) {
        self.total = total
        self.split = split
        self.engine = engine
    }
    
    init(lap: Lap, engine: Engine = .native) {
        let total = lap.progress - lap.total
        let split = lap.progress - lap.split
        self.init(total: total, split: split, engine: engine)
    }
    
    var body: some View {
        switch engine {
        case .native:
            Native(total: total, split: split)
        case .dsl:
            DSL(total: total, split: split)
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

