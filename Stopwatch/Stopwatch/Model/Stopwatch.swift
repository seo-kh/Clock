//
//  Stopwatch.swift
//  Stopwatch
//
//  Created by alphacircle on 1/8/26.
//

import Foundation
import Observation
import Combine

@Observable
final class Stopwatch {
    private(set) var laps: [Lap] = []
    private(set) var components: [ActionComponent] = []
    
    private var timer = Timer.publish(every: 0.03, on: .current, in: .common)
    private var cancel: Cancellable? = nil
    
    init() {
        self.setResetButtons()
    }
}

/// Button Actions: Feature + UI update
private extension Stopwatch {
    func lap() {
        addLap()
    }
    
    func start() {
        configureLaps()
        startTimer()
        setStartButtons()
    }
    
    func stop() {
        stopTimer()
        setStopButtons()
    }
    
    func reset() {
        resetLaps()
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

/// Timer Control
extension Stopwatch {
    private func startTimer() {
        cancel = timer
            .autoconnect()
            .sink(receiveValue: { [weak self] date in
                self?.laps[0].progress = date
            })
    }
    
    private func stopTimer() {
        cancel?.cancel()
        cancel = nil
    }
}

/// Lap Control
extension Stopwatch {
    private func addLap() {
        let newLap: Lap = self.laps[0].next()
        self.laps.insert(newLap, at: 0)
    }
    
    private func resetLaps() {
        self.laps.removeAll()
    }
    
    private func configureLaps() {
        if laps.isEmpty {
            let now: Date = Date.now
            laps.append(Lap(number: 1, split: now, total: now, progress: now))
        } else {
            laps[0].adjust()
        }
    }
}
