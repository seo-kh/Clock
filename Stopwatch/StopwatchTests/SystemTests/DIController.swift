//
//  DIController.swift
//  StopwatchTests
//
//  Created by alphacircle on 3/11/26.
//

import Foundation
@testable import Stopwatch

@MainActor
enum DIController {
    static func bootTest1() -> BootController {
        let flag = MockStartFlagAdapter(isActive: false)
        let lap = MockLapAdapter(laps: .dummy)
        let lifecycle = MockLifecycleAdapter(isActive: true)
        let service = BootService(loadStartFlagPort: flag, loadLapPort: lap, lifecyclePort: lifecycle)
        let bootController = BootController(useCase: service)
        return bootController
    }
    
    static func lapTest1() -> BootController {
        let flag = MockStartFlagAdapter(isActive: false)
        let lap = MockLapAdapter(laps: [])
        let lifecycle = MockLifecycleAdapter(isActive: true)
        let service = BootService(loadStartFlagPort: flag, loadLapPort: lap, lifecyclePort: lifecycle)
        let bootController = BootController(useCase: service)
        return bootController
    }
    
    static func lapTest2() -> (BootController, LapController) {
        let flag = MockStartFlagAdapter(isActive: false)
        let lap = MockLapAdapter(laps: [Lap.empty])
        let lifecycle = MockLifecycleAdapter(isActive: true)
        
        let lapService = LapService(updateLapPort: lap)
        let bootService = BootService(loadStartFlagPort: flag, loadLapPort: lap, lifecyclePort: lifecycle)
        
        let bootController = BootController(useCase: bootService)
        let lapController = LapController(lapUseCase: lapService)
        return (bootController, lapController)
    }
    
    static func lapTest3(lap: MockLapAdapter) -> _Stopwatch {
        let flag = MockStartFlagAdapter(isActive: false)
        let lifecycle = MockLifecycleAdapter(isActive: true)
        
        let lapService = LapService(updateLapPort: lap)
        let bootService = BootService(loadStartFlagPort: flag, loadLapPort: lap, lifecyclePort: lifecycle)
        
        let bootController = BootController(useCase: bootService)
        let lapController = LapController(lapUseCase: lapService)
        return _Stopwatch(bootController: bootController, lapController: lapController)
    }
    
    static func lapTest4() -> _Stopwatch {
        let flag = MockStartFlagAdapter(isActive: false)
        let lifecycle = MockLifecycleAdapter(isActive: true)
        let lap = MockLapAdapter(laps: [Lap.empty])

        let lapService = LapService(updateLapPort: lap)
        let bootService = BootService(loadStartFlagPort: flag, loadLapPort: lap, lifecyclePort: lifecycle)
        
        let bootController = BootController(useCase: bootService)
        let lapController = LapController(lapUseCase: lapService)
        return _Stopwatch(bootController: bootController, lapController: lapController)
    }

}

