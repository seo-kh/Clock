//
//  Tick.swift
//  WatchUI
//
//  Created by 테스트 on 2/28/26.
//

import Foundation

public struct Tick {
    public let base: Int
    public let offset: Int
    public let delta: TimeInterval
    public var mark: TimeInterval {
        TimeInterval(base) + TimeInterval(offset) * delta
    }
    
    public var isBase: Bool {
        offset == 0
    }
    
    public var isOrigin: Bool {
        base == 0 && offset == 0
    }

    public init(base: Int, offset: Int = 0, delta: TimeInterval = 1) {
        self.base = base
        self.offset = offset
        self.delta = delta
    }
    
    public func isMultiple(of other: TimeInterval) -> Bool {
        let result = mark.truncatingRemainder(dividingBy: other)
        return abs(result) < 0.0001
    }
    
}

