//
//  BootCommand.swift
//  Stopwatch
//
//  Created by alphacircle on 3/11/26.
//

import Foundation

struct BootCommand {
    let configLap: (Result<[Lap], Error>) -> Void
    let configStartFlag: (Bool) -> Void
    let configLifecycle: (Bool) -> Void
}
