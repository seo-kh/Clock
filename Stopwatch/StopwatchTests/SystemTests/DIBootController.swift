//
//  DIBootController.swift
//  StopwatchTests
//
//  Created by alphacircle on 3/11/26.
//

import Foundation
@testable import Stopwatch

enum DIBootController {
    static func test1() -> StopwatchBootController {
        let mode = MockModeAdapter(isActive: false)
        let lap = MockLapAdapter(laps: .dummy)
        let lifecycle = MockLifecycleAdapter(isActive: true)
        let service = StopwatchBootService(loadModePort: mode, loadLapPort: lap, lifecyclePort: lifecycle)
        let bootController = StopwatchBootController(useCase: service)
        return bootController
    }
}

