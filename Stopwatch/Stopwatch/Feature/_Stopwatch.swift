//
//  _Stopwatch.swift
//  Stopwatch
//
//  Created by alphacircle on 3/11/26.
//

import Foundation

protocol UpdateLapPort {
    func update(_ target: Lap)
}

final class _Stopwatch {
    private(set) var laps: [Lap] = []
    private(set) var components: [ActionComponent] = []
    private(set) var isActive: Bool = false
    private(set) var watchMode: WatchMode!
    
    private var bootController: BootController
    
    private var updateLapPort: UpdateLapPort!
    
    init(bootController: BootController) {
        self.bootController = bootController
        self.boot()
    }
    
    private func boot() {
        self.bootController.boot(target: self)
        self.components = .idle
    }
    
    func lap() {
        guard let newLap: Lap = self.laps.first?.next() else { return }
        // self.laps.insert(newLap, at: 0)
        // self.context?.insert(newLap)
        self.updateLapPort.update(newLap)
        
        // 상태처리코드라서 Stopwatch에 존재하는게 맞음
         if watchMode.isActive {
             watchMode.change()
         }
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
        self.laps.insert(target, at: 0)
    }
    
    func didChangeLifecycle(_ target: Bool) {
        self.isActive = target
    }
    
    func didChangeStartFlag(_ target: Bool) {
        // self.watchMode = target
    }
}
