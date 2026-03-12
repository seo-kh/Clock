//
//  LapCommand.swift
//  Stopwatch
//
//  Created by alphacircle on 3/12/26.
//

import Foundation

struct LapCommand {
    let source: Lap
    let configNewLap: (Lap) -> Void
}
