//
//  Lap.swift
//  Stopwatch
//
//  Created by alphacircle on 1/6/26.
//

import Foundation
import SwiftData

@Model
final class Lap {
    @Attribute(.unique)
    var id: Int
    
    var number: String {
        "Lap \(id)"
    }
    var split: Date
    var total: Date
    var progress: Date
    
    init(number: Int, split: Date, total: Date, progress: Date) {
        self.id = number
        self.split = split
        self.total = total
        self.progress = progress
    }
}

extension Lap: Comparable {
    static func < (lhs: Lap, rhs: Lap) -> Bool {
        let lhsSplitInterval: TimeInterval = lhs.progress - lhs.split
        let rhsSplitInterval: TimeInterval = rhs.progress - rhs.split
        return lhsSplitInterval < rhsSplitInterval
    }
}

extension Lap {
    /// Lap의 기록을 현재 날짜 기준으로 재조정
    func adjust() {
        let now: Date = Date.now
        let splitInterval: TimeInterval = progress - split
        let totalInterval: TimeInterval = progress - total
        
        self.split = now - splitInterval
        self.total = now - totalInterval
        self.progress = now
    }
    
    /// Lap의 기록을 기반으로 다음 Lap을 생성
    ///
    /// 전체 걸린 시간기록을 다음 Lap이 전달받는다.
    /// 다음 Lap의 number는 현재 Lap에 +1을 한다.
    func next() -> Lap {
        // lap num
        let nextId: Int = self.id + 1
        // lap total
        let totalInterval: TimeInterval = progress - total
        let now: Date = Date.now
        let newTotal: Date = now - totalInterval
        // new lap
        return Lap(number: nextId, split: now, total: newTotal, progress: now)
    }
    
    static let empty: Lap = Lap(number: 0, split: Date.now, total: Date.now, progress: Date.now)
}

extension Array where Element == Lap {
    static let dummy: Self = [
        Lap(number: 0, split: .now + 30.0, total: .now, progress: .now + 120.0),
        Lap(number: 1, split: .now + 40.0, total: .now, progress: .now + 140.0),
        Lap(number: 2, split: .now + 50.0, total: .now, progress: .now + 160.0),
        Lap(number: 3, split: .now + 60.0, total: .now, progress: .now + 180.0),
        Lap(number: 4, split: .now + 70.0, total: .now, progress: .now + 200.0),
        Lap(number: 5, split: .now + 80.0, total: .now, progress: .now + 220.0),
        Lap(number: 6, split: .now + 90.0, total: .now, progress: .now + 240.0),
    ]
}
