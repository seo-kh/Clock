//
//  Lap.swift
//  Stopwatch
//
//  Created by alphacircle on 1/6/26.
//

import SwiftUI

struct Lap {
    private let _number: Int
    var number: String {
        "Lap \(_number)"
    }
    var split: Date
    var total: Date
    var progress: Date
    
    init(number: Int, split: Date, total: Date, progress: Date) {
        self._number = number
        self.split = split
        self.total = total
        self.progress = progress
    }
}

extension Lap: Identifiable {
    var id: String { self.number }
}

extension Lap: Comparable {
    static func < (lhs: Lap, rhs: Lap) -> Bool {
        let lhsSplitInterval: TimeInterval = lhs.progress - lhs.split
        let rhsSplitInterval: TimeInterval = rhs.progress - rhs.split
        return lhsSplitInterval < rhsSplitInterval
    }
}

extension Lap {
    mutating func adjust() {
        let now: Date = Date.now
        let splitInterval: TimeInterval = progress - split
        let totalInterval: TimeInterval = progress - total
        
        self.split = now - splitInterval
        self.total = now - totalInterval
        self.progress = now
    }
    
    func next() -> Lap {
        // lap num
        let nextNumber: Int = self._number + 1
        // lap total
        let totalInterval: TimeInterval = progress - total
        let now: Date = Date.now
        let newTotal: Date = now - totalInterval
        // new lap
        return Lap(number: nextNumber, split: now, total: newTotal, progress: now)
    }
    
    static let empty: Lap = Lap(number: 0, split: Date.now, total: Date.now, progress: Date.now)
}

