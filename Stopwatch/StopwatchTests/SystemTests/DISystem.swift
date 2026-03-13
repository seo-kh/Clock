//
//  DISystem.swift
//  StopwatchTests
//
//  Created by alphacircle on 3/11/26.
//

import Foundation
@testable import Stopwatch

@MainActor
enum DISystem {
    static func lapTest1() -> _Stopwatch {
        // out port
        let flag = MockStartFlagAdapter(isActive: false)
        let lap = MockLapAdapter(laps: [])
        let lifecycle = MockLifecycleAdapter(isActive: true)
        
        // service
        let bootService = BootService(loadStartFlagPort: flag,
                                      loadLapPort: lap,
                                      lifecyclePort: lifecycle)
        
        // controller
        let bootController = BootController(loadLapUseCase: bootService,
                                            loadStartFlagUseCase: bootService,
                                            updateLifecycleUseCase: bootService)
        
        // system
        let stopwatch = _Stopwatch(bootController: bootController,
                                   lapController: nil,
                                   startController: nil,
                                   stopController: nil,
                                   resetController: nil)
        return stopwatch
    }
    
    static func lapTest2() -> _Stopwatch {
        // out port
        let flag = MockStartFlagAdapter(isActive: false)
        let lap = MockLapAdapter(laps: [Lap.empty])
        let lifecycle = MockLifecycleAdapter(isActive: true)
        
        // service
        let lapService = LapService(updateLapPort: lap)
        let bootService = BootService(loadStartFlagPort: flag,
                                      loadLapPort: lap,
                                      lifecyclePort: lifecycle)
        
        // controller
        let bootController = BootController(loadLapUseCase: bootService,
                                            loadStartFlagUseCase: bootService,
                                            updateLifecycleUseCase: bootService)
        let lapController = LapController(lapUseCase: lapService)
        
        // system
        let stopwatch = _Stopwatch(bootController: bootController,
                                   lapController: lapController,
                                   startController: nil,
                                   stopController: nil,
                                   resetController: nil)
        return stopwatch
    }

    
    static func lapTest3() -> _Stopwatch {
        // out port
        let flag = MockStartFlagAdapter(isActive: false)
        let lifecycle = MockLifecycleAdapter(isActive: true)
        let lap = MockLapAdapter(laps: [Lap.empty])

        // service
        let lapService = LapService(updateLapPort: lap)
        let bootService = BootService(loadStartFlagPort: flag,
                                      loadLapPort: lap,
                                      lifecyclePort: lifecycle)
        
        // controller
        let bootController = BootController(loadLapUseCase: bootService,
                                            loadStartFlagUseCase: bootService,
                                            updateLifecycleUseCase: bootService)
        let lapController = LapController(lapUseCase: lapService)
        
        // system
        let stopwatch = _Stopwatch(bootController: bootController,
                          lapController: lapController,
                          startController: nil,
                          stopController: nil,
                          resetController: nil)
        // watchMode == true
        stopwatch.watchMode.change()
        return stopwatch
    }
    
    static func startTest1() -> _Stopwatch {
        // out port
        let lapPort = MockLapAdapter(laps: [Lap.empty])
        let flagPort = MockStartFlagAdapter(isActive: false)
        let lifecycle = MockLifecycleAdapter(isActive: true)
        let timer = LocalTimer(0.03)
        
        // service
        let startService = StartService(resumeTimerPort: timer,
                                        updateStartFlagPort: flagPort,
                                        updateLapPort: lapPort)
        let bootService = BootService(loadStartFlagPort: flagPort,
                                      loadLapPort: lapPort,
                                      lifecyclePort: lifecycle)
        
        // controller
        let startController = StartController(configureLapUseCase: startService,
                                    startTimerUseCase: startService,
                                    setStartFlagUseCase: nil)
        let bootController = BootController(loadLapUseCase: bootService,
                                  loadStartFlagUseCase: nil,
                                  updateLifecycleUseCase: nil)
        // system
        let stopwatch = _Stopwatch(bootController: bootController,
                                   lapController: nil,
                                   startController: startController,
                                   stopController: nil,
                                   resetController: nil)
        
        return stopwatch
    }
    
    static func stopTest1() -> _Stopwatch {
        // out port
        let lapPort = MockLapAdapter(laps: [])
        let flag = MockStartFlagAdapter(isActive: false)
        let timer = LocalTimer(0.03)
        
        // service
        let startService = StartService(resumeTimerPort: timer,
                                        updateStartFlagPort: flag,
                                        updateLapPort: lapPort)
        let stopService = StopService(cancelTimerPort: timer,
                                      updateStartFlagPort: flag)
        
        // controller
        let startController = StartController(configureLapUseCase: startService,
                                    startTimerUseCase: startService,
                                    setStartFlagUseCase: nil)
        let stopController = StopController(stopTimerUseCase: stopService,
                                            setStartFlagUseCase: nil)
        
        // system
        let stopwatch = _Stopwatch(bootController: nil,
                                   lapController: nil,
                                   startController: startController,
                                   stopController: stopController,
                                   resetController: nil)
        return stopwatch
    }
    
    static func stopTest2() -> _Stopwatch {
        stopTest1()
    }
    
    static func resetTest1() -> _Stopwatch {
        // out port
        let lap = MockLapAdapter(laps: [])
        let flag = MockStartFlagAdapter(isActive: false)
        let timer = LocalTimer(0.03)

        // service
        let lapService = LapService(updateLapPort: lap)
        let startService = StartService(resumeTimerPort: timer,
                                        updateStartFlagPort: flag,
                                        updateLapPort: lap)
        let stopService = StopService(cancelTimerPort: timer,
                                      updateStartFlagPort: flag)
        let resetService = ResetService(resetLapPort: lap)
        
        // controller
        let lapController = LapController(lapUseCase: lapService)
        let start = StartController(configureLapUseCase: startService,
                                    startTimerUseCase: startService,
                                    setStartFlagUseCase: startService)
        let stop = StopController(stopTimerUseCase: stopService,
                                  setStartFlagUseCase: stopService)
        let reset = ResetController(resetLapUseCase: resetService)
        
        return _Stopwatch(bootController: nil,
                          lapController: lapController,
                          startController: start,
                          stopController: stop,
                          resetController: reset)
    }

}

