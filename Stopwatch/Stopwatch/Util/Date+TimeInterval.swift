//
//  Date+TimeInterval.swift
//  Stopwatch
//
//  Created by alphacircle on 1/8/26.
//

import Foundation

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSince(rhs)
    }
}
