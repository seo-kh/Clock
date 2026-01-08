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
    var laps: [Lap]
    var buttons: [ActionButton]
    
    init() {
        self.laps = []
        self.buttons = []
        self.buttons.append(contentsOf:
                                [
                                    ActionButton(title: "Lap", action: nil, style: .ckDisable),
                                    ActionButton(title: "Start", action: self.start, style: .ckGreen),
                                ])
    }
    
    @ObservationIgnored
    var state: State = State.idle {
        didSet {
            self.buttons =
            switch state {
            case .idle:
                [
                    ActionButton(title: "Lap", action: nil, style: .ckDisable),
                    ActionButton(title: "Start", action: self.start, style: .ckGreen),
                ]
            case .run:
                [
                    ActionButton(title: "Lap", action: self.lap, style: .ckGray),
                    ActionButton(title: "Stop", action: self.stop, style: .ckRed),
                ]
            case .pause:
                [
                    ActionButton(title: "Reset", action: self.reset, style: .ckGray),
                    ActionButton(title: "Start", action: self.start, style: .ckGreen),
                ]
            }
        }
    }
    
    var timer = Timer.publish(every: 0.03, on: .current, in: .common)
    var cancel: Cancellable?
    
    enum State {
        case idle
        case run
        case pause
    }
    
    func lap() {
        let newLap: Lap = self.laps[0].next()
        self.laps.insert(newLap, at: 0)
    }
    
    func start() {
        if laps.isEmpty {
            let now: Date = Date.now
            laps.append(Lap(number: 1, split: now, total: now, progress: now))
        } else {
            laps[0].adjust()
        }
        
        cancel = timer
            .autoconnect()
            .sink(receiveValue: { [weak self] date in
                self?.laps[0].progress = date
            })
        
        self.state = .run
    }
    
    func stop() {
        cancel?.cancel()
        self.state = .pause
    }
    
    func reset() {
        self.laps.removeAll()
        self.state = .idle
    }
}


