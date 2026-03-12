//
//  _Stopwatch.swift
//  Stopwatch
//
//  Created by alphacircle on 3/11/26.
//

import Foundation

final class _Stopwatch {
    private(set) var laps: [Lap] = []
    private(set) var components: [ActionComponent] = .idle
    private(set) var isActive: Bool = false
    private(set) var watchMode: WatchMode = WatchMode(isActive: false, change: {})
    
    private var bootController: BootController?
    private var lapController: LapController?
    private var startController: StartController?
    private var stopController: StopController?
    
    init(bootController: BootController?,
         lapController: LapController?,
         startController: StartController?,
         stopController: StopController?) {
        self.bootController = bootController
        self.lapController = lapController
        self.startController = startController
        self.stopController = stopController
        self.boot()
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
            self?.didAddLap(result)
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
