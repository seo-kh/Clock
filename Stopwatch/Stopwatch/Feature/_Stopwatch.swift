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
    
    init(bootController: BootController?,
         lapController: LapController?) {
        self.bootController = bootController
        self.lapController = lapController
        self.boot()
    }
    
    private func boot() {
        self.bootController?.boot(target: self)
        self.watchMode.change = { self.watchMode.isActive.toggle() }
    }
    
    func lap() {
        guard let firstLap: Lap = self.laps.first else { return }
        self.lapController?.lap(firstLap, target: self)
    }
}

extension _Stopwatch: StopwatchControllerDelegate {
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
        // self.watchMode = target
    }
}
