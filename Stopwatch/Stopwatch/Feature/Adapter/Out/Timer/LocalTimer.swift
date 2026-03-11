//
//  LocalTimer.swift
//  Stopwatch
//
//  Created by alphacircle on 3/10/26.
//

import Foundation

final class LocalTimer: ResumeTimerPort, CancelTimerPort {
    let interval: TimeInterval
    private var timer: Timer? = nil
    private var callback: ((TimeInterval) -> Void)?
    private var startData: Date = Date.now
    
    init(_ interval: TimeInterval) {
        self.interval = interval
    }
    
    func resume(callback: @escaping (TimeInterval) -> Void) {
        self.callback = callback
        self.startData = Date.now
        self.timer = Timer.scheduledTimer(timeInterval: interval,
                                          target: self,
                                          selector: #selector(startTimer),
                                          userInfo: nil,
                                          repeats: true)
        self.timer?.fire()
    }
    
    @objc private func startTimer(_ timer: Timer) {
        self.callback?(timer.fireDate - startData)
    }
    
    func cancel() {
        self.timer?.invalidate()
        self.timer = nil
        self.callback = nil
    }
}
