//
//  LoadLapCommand.swift
//  Stopwatch
//
//  Created by alphacircle on 3/12/26.
//

import Foundation

struct LoadLapCommand {
    let configureLaps: (Result<[Lap], Error>) -> Void
}
