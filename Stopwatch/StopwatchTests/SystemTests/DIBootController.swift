//
//  DIBootController.swift
//  StopwatchTests
//
//  Created by alphacircle on 3/11/26.
//

import Foundation
@testable import Stopwatch

enum DIBootController {
    static func bootTest1() -> BootController {
        let flag = MockStartFlagAdapter(isActive: false)
        let lap = MockLapAdapter(laps: .dummy)
        let lifecycle = MockLifecycleAdapter(isActive: true)
        let service = StopwatchBootService(loadStartFlagPort: flag, loadLapPort: lap, lifecyclePort: lifecycle)
        let bootController = BootController(useCase: service)
        return bootController
    }
    
    static func lapTest1() -> BootController {
        let flag = MockStartFlagAdapter(isActive: false)
        let lap = MockLapAdapter(laps: [])
        let lifecycle = MockLifecycleAdapter(isActive: true)
        let service = StopwatchBootService(loadStartFlagPort: flag, loadLapPort: lap, lifecyclePort: lifecycle)
        let bootController = BootController(useCase: service)
        return bootController
    }
    
    static func lapTest2() -> BootController {
        let flag = MockStartFlagAdapter(isActive: false)
        let lap = MockLapAdapter(laps: [Lap.empty])
        let lifecycle = MockLifecycleAdapter(isActive: true)
        let service = StopwatchBootService(loadStartFlagPort: flag, loadLapPort: lap, lifecyclePort: lifecycle)
        let bootController = BootController(useCase: service)
        return bootController
    }
}

