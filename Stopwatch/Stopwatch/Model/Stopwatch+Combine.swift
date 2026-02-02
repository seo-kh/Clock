//
//  Stopwatch+Combine.swift
//  Stopwatch
//
//  Created by alphacircle on 1/19/26.
//

import Foundation
import Combine

final class StopwatchPublisher {
    private(set) var laps = CurrentValueSubject<[Lap], Never>([])
    private(set) var components = CurrentValueSubject<[ActionComponent], Never>([])
    private(set) var isActive = CurrentValueSubject<Bool, Never>(true)
    
    private var cancellables: Set<AnyCancellable> = []
    private var timerCanceller: Cancellable? = nil
    
    init() {
        self.components.value = [
            ActionComponent(title: "Lap", action: nil, style: .ckDisable),
            ActionComponent(title: "Start", action: self.start, style: .ckGreen),
        ]
    }
    
    func start() {
        configureLaps()
        startTimer()
    }
    
    private func startTimer() {
        timerCanceller = Timer.publish(every: 0.03, on: .current, in: .common)
            .autoconnect()
            .sink(receiveValue: { date in
                self.laps.value.first?.progress = date
            })
    }
    
    private func stopTimer() {
        timerCanceller?.cancel()
        timerCanceller = nil
    }
    
    private func configureLaps() {
        if laps.value.isEmpty {
            let now: Date = Date.now
            let newLap = Lap(number: 1, split: now, total: now, progress: now)
            laps.value.append(newLap)
        } else {
            laps.value[0].adjust()
        }
    }
}
