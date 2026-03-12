//
//  SDLap.swift
//  Stopwatch
//
//  Created by alphacircle on 3/12/26.
//

import Foundation
import SwiftData

/// Lap Schema for SwiftData
@Model
final class SDLap {
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
