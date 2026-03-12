//
//  ConfigureLapCommand.swift
//  Stopwatch
//
//  Created by alphacircle on 3/12/26.
//

import Foundation

struct ConfigureLapCommand {
    let laps: [Lap]
    let configLap: (Result<[Lap], Error>) -> Void
}
