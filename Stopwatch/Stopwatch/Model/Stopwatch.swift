//
//  Stopwatch.swift
//  Stopwatch
//
//  Created by james seo on 1/8/26.
//

import Foundation
import Observation

@Observable
final class Stopwatch {
    private(set) var laps: [Lap] = []
    private(set) var components: [ActionComponent] = []
    private(set) var isActive: Bool = false
    private(set) var watchMode: WatchMode!
    
    private let controller: StopwatchController
    
    init() {
        self.controller = StopwatchController(factory: ProductionFactory())
        self.controller.configure(delegate: self)
        self.watchMode = WatchMode(isActive: false, change: self.changeWatchMode)
    }
}

/// listen events
extension Stopwatch: StopwatchControllerDelegate {
    func didUpdate(_ date: Date) {
        guard !laps.isEmpty else { return }
        
        self.laps[0].progress = date
    }
    
    func didUpdate(_ activation: Bool) {
        self.isActive = activation
    }
    
    func didGet(_ laps: [Lap]) {
        self.laps = laps
    }
    
    func didGet(_ flag: Bool) {
        if flag {
            self.start()
            self.setStartButtons()
        } else {
            self.setResetButtons()
        }
    }
    
    func didCompleteWithError(_ error: any Error) {
        print(error)
    }
}

/// Button Actions: Feature + UI update
private extension Stopwatch {
    func lap() {
        controller.lap(in: &laps)
        
        if watchMode.isActive {
            changeWatchMode()
        }
    }
    
    func start() {
        controller.start(in: &laps)
        setStartButtons()
    }
    
    func stop() {
        controller.stop()
        setStopButtons()
    }
    
    func reset() {
        controller.reset()
        self.laps.removeAll()
        setResetButtons()
    }
}

/// Button Configure
extension Stopwatch {
    private func setResetButtons() {
        self.components = [
            ActionComponent(title: "Lap", action: nil, style: .ckDisable),
            ActionComponent(title: "Start", action: self.start, style: .ckGreen),
        ]
    }
    private func setStartButtons() {
        self.components = [
            ActionComponent(title: "Lap", action: self.lap, style: .ckGray),
            ActionComponent(title: "Stop", action: self.stop, style: .ckRed),
        ]
    }
    private func setStopButtons() {
        self.components = [
            ActionComponent(title: "Reset", action: self.reset, style: .ckGray),
            ActionComponent(title: "Start", action: self.start, style: .ckGreen),
        ]
    }
}

private extension Stopwatch {
    func changeWatchMode() {
        self.watchMode.isActive.toggle()
    }
}
