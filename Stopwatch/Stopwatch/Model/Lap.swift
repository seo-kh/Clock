//
//  Lap.swift
//  Stopwatch
//
//  Created by alphacircle on 1/6/26.
//

import Foundation

struct Lap: Identifiable {
    let number: String
    var split: String
    var total: String
    
    var id: String { self.number }
}

// convenience logic
extension Lap {
    // dummy
    static let dummy = Lap(number: "Lap 3", split: "00:10.00", total: "00:19.08")
}

extension Array where Element == Lap {
    // dummy
    static let dummy: [Lap] = [
        Lap(number: "Lap 2", split: "00:06.05", total: "00:09.08"),
        Lap(number: "Lap 1", split: "00:03.03", total: "00:03.03"),
    ]
}
