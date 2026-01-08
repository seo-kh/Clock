//
//  StopwatchScreen.swift
//  Stopwatch
//
//  Created by alphacircle on 1/5/26.
//

import SwiftUI
import Foundation
import Observation
import Combine

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSince(rhs)
    }
}

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


struct StopwatchScreen: View {
    @State
    var stopwatch = Stopwatch()
    
    var body: some View {
        _StopwatchScreen(laps: stopwatch.laps,
                         buttons: stopwatch.buttons)
    }
}

extension StopwatchScreen {
    /// Stateless Stopwatch UI Screen
    struct _StopwatchScreen: View {
        let laps: [Lap]
        let buttons: [ActionButton]
        
        private var currentLap: Lap {
            switch laps.first {
            case .none: Lap.empty
            case .some(let _current): _current
            }
        }
        
        var body: some View {
            VStack(alignment: .center, spacing: 0.0) {
                TimeLabel(lap: currentLap)
                    .padding(.vertical, 20.0)
                
                LapList(laps: laps)
                
                ActionGroup(buttons: buttons)
                    .padding(.vertical, 40.0)
            }
            .frame(maxWidth: CGFloat.infinity, maxHeight: CGFloat.infinity)
            .background(CKColor.background)
        }
    }
}

#Preview("Start") {
    StopwatchScreen._StopwatchScreen(laps: [], buttons: [])
        .frame(
            minWidth: 600,
            idealWidth: 600,
            maxWidth: CGFloat.infinity,
            minHeight: 610,
            idealHeight: 610,
            maxHeight: CGFloat.infinity
        )
}

#Preview("Empty") {
    StopwatchScreen._StopwatchScreen(laps: [], buttons: [])
        .frame(
            minWidth: 600,
            idealWidth: 600,
            maxWidth: CGFloat.infinity,
            minHeight: 610,
            idealHeight: 610,
            maxHeight: CGFloat.infinity
        )
}

#Preview("Stopwatch") {
    StopwatchScreen._StopwatchScreen(laps: [], buttons: [])
        .frame(
            minWidth: 600,
            idealWidth: 600,
            maxWidth: CGFloat.infinity,
            minHeight: 610,
            idealHeight: 610,
            maxHeight: CGFloat.infinity
        )
}


