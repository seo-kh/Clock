//
//  StopwatchConfig.swift
//  Stopwatch
//
//  Created by alphacircle on 3/13/26.
//

import Foundation

final class StopwatchConfig {
    private(set) var bootController: BootController?
    private(set) var lapController: LapController?
    private(set) var startController: StartController?
    private(set) var stopController: StopController?
    private(set) var resetController: ResetController?
    
    private init(loadStartFlagPort: LoadStartFlagPort,
         updateStartFlagPort: UpdateStartFlagPort,
         loadLapPort: LoadLapPort,
         updateLapPort: UpdateLapPort,
         resetLapPort: ResetLapPort,
         lifecyclePort: ListenLifecyclePort,
         resumeTimerPort: ResumeTimerPort,
         cancelTimerPort: CancelTimerPort,
    ) {
        // service
        let bootService = BootService(loadStartFlagPort: loadStartFlagPort,
                                      loadLapPort: loadLapPort,
                                      lifecyclePort: lifecyclePort)
        let lapService = LapService(updateLapPort: updateLapPort)
        let startService = StartService(resumeTimerPort: resumeTimerPort,
                                        updateStartFlagPort: updateStartFlagPort,
                                        updateLapPort: updateLapPort)
        let stopService = StopService(cancelTimerPort: cancelTimerPort,
                                      updateStartFlagPort: updateStartFlagPort)
        let resetService = ResetService(resetLapPort: resetLapPort)
        
        // controller
        let bootController = BootController(loadLapUseCase: bootService,
                                            loadStartFlagUseCase: bootService,
                                            updateLifecycleUseCase: bootService)
        let lapController = LapController(lapUseCase: lapService)
        let startController = StartController(configureLapUseCase: startService,
                                              startTimerUseCase: startService,
                                              setStartFlagUseCase: startService)
        let stopController = StopController(stopTimerUseCase: stopService,
                                            setStartFlagUseCase: stopService)
        let resetController = ResetController(resetLapUseCase: resetService)
        
        self.bootController = bootController
        self.lapController = lapController
        self.startController = startController
        self.stopController = stopController
        self.resetController = resetController
    }
}

extension StopwatchConfig {
    static func memory(timeInterval: Double) -> StopwatchConfig {
        let lap = LapMemoryAdapter()
        let flag = StartFlagMemoryAdapter()
        let lifecycle = AppLifecycleAdapter()
        let timer = LocalTimer(timeInterval)
        
        return StopwatchConfig(loadStartFlagPort: flag,
                  updateStartFlagPort: flag,
                  loadLapPort: lap,
                  updateLapPort: lap,
                  resetLapPort: lap,
                  lifecyclePort: lifecycle,
                  resumeTimerPort: timer,
                  cancelTimerPort: timer)
    }
}
