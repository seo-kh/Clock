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
        return _Stopwatch(bootController: bootController, lapController: lapController, startController: nil)
    }
    
    static func lapTest4() -> _Stopwatch {
        let flag = MockStartFlagAdapter(isActive: false)
        let lifecycle = MockLifecycleAdapter(isActive: true)
        let lap = MockLapAdapter(laps: [Lap.empty])

        let lapService = LapService(updateLapPort: lap)
        let bootService = BootService(loadStartFlagPort: flag, loadLapPort: lap, lifecyclePort: lifecycle)
        
        let bootController = BootController(useCase: bootService)
        let lapController = LapController(lapUseCase: lapService)
        return _Stopwatch(bootController: bootController, lapController: lapController, startController: nil)
    }
    
    static func startTest1() -> StartController {
        let updateLapPort = MockLapAdapter(laps: [])
        let configureService = ConfigureLapService(updateLapPort: updateLapPort)
        return StartController(configureLapUseCase: configureService, startTimerUseCase: nil, setStartFlagUseCase: nil)
    }

    static func startTest2() -> (BootController, StartController) {
        let pivot = Date(timeIntervalSince1970: 199)
        let lap = Lap(number: 1, split: pivot.addingTimeInterval(30), total: pivot.addingTimeInterval(10), progress: pivot.addingTimeInterval(50))
        let lapPort = MockLapAdapter(laps: [lap])
        let flagPort = MockStartFlagAdapter(isActive: false)
        let lifecycle = MockLifecycleAdapter(isActive: true)
        
        let configureService = ConfigureLapService(updateLapPort: lapPort)
        let bootService = BootService(loadStartFlagPort: flagPort, loadLapPort: lapPort, lifecyclePort: lifecycle)
        
        let start = StartController(configureLapUseCase: configureService, startTimerUseCase: nil, setStartFlagUseCase: nil)
        let boot = BootController(useCase: bootService)
        
        return (boot, start)
    }
    
    static func startTest3() -> (BootController, StartController) {
        let lapPort = MockLapAdapter(laps: [])
        let flagPort = MockStartFlagAdapter(isActive: false)
        let lifecycle = MockLifecycleAdapter(isActive: true)
        
        let configureService = ConfigureLapService(updateLapPort: lapPort)
        let startTimerService = StartTimerService(resumeTimerPort: LocalTimer(0.03))
        let bootService = BootService(loadStartFlagPort: flagPort, loadLapPort: lapPort, lifecyclePort: lifecycle)
        
        let start = StartController(configureLapUseCase: configureService, startTimerUseCase: startTimerService, setStartFlagUseCase: nil)
        let boot = BootController(useCase: bootService)
        
        return (boot, start)
    }
    
    static func startTest4(flagPort: MockStartFlagAdapter) -> (BootController, StartController) {
        let lapPort = MockLapAdapter(laps: [])
        let lifecycle = MockLifecycleAdapter(isActive: true)
        
        let configureService = ConfigureLapService(updateLapPort: lapPort)
        let bootService = BootService(loadStartFlagPort: flagPort, loadLapPort: lapPort, lifecyclePort: lifecycle)
        let flagService = StartFlagService(updateStartFlagPort: flagPort)
        
        let start = StartController(configureLapUseCase: configureService, startTimerUseCase: nil, setStartFlagUseCase: flagService)
        let boot = BootController(useCase: bootService)
        
        return (boot, start)
    }
}

