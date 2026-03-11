//
//  _Stopwatch.swift
//  Stopwatch
//
//  Created by alphacircle on 3/11/26.
//

import Foundation

final class _Stopwatch {
    private(set) var laps: [Lap] = []
    private(set) var components: [ActionComponent] = []
    private(set) var isActive: Bool = false
    private(set) var watchMode: WatchMode!
    
    private var bootController: StopwatchBootController
    
    init(bootController: StopwatchBootController) {
        self.bootController = bootController
        self.boot()
    }
    
    private func boot() {
        self.bootController.boot(target: self)
        self.components = .idle
    }
}

extension _Stopwatch: StopwatchBootControllerDelegate {
    func lap(_ target: Result<[Lap], any Error>) {
        switch target {
        case .success(let laps):
            self.laps = laps
        case .failure(let error):
            print(error)
        }
    }
    
    func lifecycle(_ target: Bool) {
        self.isActive = target
    }
    
    func mode(_ target: WatchMode) {
        self.watchMode = target
    }
}
