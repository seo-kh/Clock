//
//  _Stopwatch.swift
//  Stopwatch
//
//  Created by alphacircle on 3/11/26.
//

import Foundation
import Observation

// Stopwatch Module
//
// [fix table]
// 1. isActive를 삭제하고, component가 isActive 가지도록 설정 <- state줄이기 위함
// 2. watchMode를 삭제하고, 단일 Bool state 상태 설정
// 3. configuration 객체 생성

final class StopwatchConfig {
    var bootController: BootController?
    var lapController: LapController?
    var startController: StartController?
    var stopController: StopController?
    var resetController: ResetController?
    
    private var loadStartFlagPort: LoadStartFlagPort
    private var updateStartFlagPort: UpdateStartFlagPort
    
    private var loadLapPort: LoadLapPort
    private var updateLapPort: UpdateLapPort
    private var resetLapPort: ResetLapPort
    
    private var lifecyclePort: ListenLifecyclePort
    
    private var resumeTimerPort: ResumeTimerPort
    private var cancelTimerPort: CancelTimerPort
    
    enum FlagConfig {
        case userDefaults
        case memory
    }
    
    enum LifecycleConfig {
        case application
    }
    
    enum PersistanceConfig {
        case memory
        case swiftData
    }
    
    enum TimerConfig {
        case local(TimeInterval)
    }
    
    init(flag: FlagConfig = .memory,
         lifecycle: LifecycleConfig = .application,
         container: PersistanceConfig = .memory,
         timer: TimerConfig = .local(0.03)
    ) {
        switch flag {
        case .userDefaults:
            let flagPort = StartFlagDefaultsAdapter()
            self.loadStartFlagPort = flagPort
            self.updateStartFlagPort = flagPort
        case .memory:
            let flagPort = StartFlagMemoryAdapter()
            self.loadStartFlagPort = flagPort
            self.updateStartFlagPort = flagPort
        }
        
        switch lifecycle {
        case .application:
            let lifecyclePort = AppLifecycleAdapter()
            self.lifecyclePort = lifecyclePort
        }
        
        switch container {
        case .memory:
            let lapPort = LapMemoryAdapter()
            self.loadLapPort = lapPort
            self.updateLapPort = lapPort
            self.resetLapPort = lapPort
        case .swiftData:
            let lapPort = LapSwiftDataAdapter()
            self.loadLapPort = lapPort
            self.updateLapPort = lapPort
            self.resetLapPort = lapPort
        }
        
        switch timer {
        case .local(let interval):
            let timerPort = LocalTimer(interval)
            self.resumeTimerPort = timerPort
            self.cancelTimerPort = timerPort
        }
    }

    func build() {
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

@Observable
final class _Stopwatch {
    private(set) var laps: [Lap] = []
    private(set) var components: [ActionComponent] = .idle
    private(set) var isActive: Bool = false
    private(set) var watchMode: WatchMode = WatchMode(isActive: false, change: {})
    
    private var bootController: BootController?
    private var lapController: LapController?
    private var startController: StartController?
    private var stopController: StopController?
    private var resetController: ResetController?
    
    init(bootController: BootController?,
         lapController: LapController?,
         startController: StartController?,
         stopController: StopController?,
         resetController: ResetController?
    ) {
        self.bootController = bootController
        self.lapController = lapController
        self.startController = startController
        self.stopController = stopController
        self.resetController = resetController
        self.boot()
    }
    
    convenience init(configuration: StopwatchConfig) {
        configuration.build()
        self.init(bootController: configuration.bootController,
                  lapController: configuration.lapController,
                  startController: configuration.startController,
                  stopController: configuration.stopController,
                  resetController: configuration.resetController)
    }
    
    private func boot() {
        self.bootController?.loadLaps { [weak self] result in
            self?.didLoadLaps(result)
        }
        
        self.bootController?.loadStartFlag { [weak self] result in
            self?.didChangeStartFlag(result)
        }
        
        self.bootController?.updateLifecycle { [weak self] result in
            self?.didChangeLifecycle(result)
        }
        
        self.watchMode.change = { self.watchMode.isActive.toggle() }
    }
    
    func lap() {
        self.lapController?.lap(at: laps) { [weak self] result in
            if let _result = result {
                self?.didAddLap(_result)
            }
        }
    }
    
    func start() {
        self.startController?.configureLaps(laps) { [weak self] result in
            self?.didLoadLaps(result)
        }
        self.startController?.startTimer { [weak self] result in
            self?.didChangeProgress(result)
        }
        
        self.startController?.enableStartFlag()
        
        // state
        self.components = .start
    }
    
    func stop() {
        self.stopController?.stopTimer()
        self.stopController?.disableStartFlag()
        
        // state
        self.components = .stop
    }
    
    func reset() {
        do {
            try self.resetController?.resetLaps()
            self.laps.removeAll()
        } catch {
            print(error)
        }
    }
}

private extension _Stopwatch {
    func didLoadLaps(_ target: Result<[Lap], any Error>) {
        switch target {
        case .success(let laps):
            self.laps = laps
        case .failure(let error):
            print(error)
        }
    }
    
    func didAddLap(_ target: Lap) {
        // lap 추가
        self.laps.insert(target, at: 0)
        
        // watchMode가 on이면, off
        if watchMode.isActive {
            watchMode.change()
        }
    }
    
    func didChangeLifecycle(_ target: Bool) {
        self.isActive = target
    }
    
    func didChangeStartFlag(_ target: Bool) {
        start()
    }
    
    func didChangeProgress(_ target: Date) {
        self.laps[0].progress = target
    }
}
