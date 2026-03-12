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
    private var callback: ((Date) -> Void)?
    
    init(_ interval: TimeInterval) {
        self.interval = interval
    }
    
    func resume(callback: @escaping (Date) -> Void) {
        self.callback = callback
        self.timer = Timer.scheduledTimer(timeInterval: interval,
                                          target: self,
                                          selector: #selector(startTimer),
                                          userInfo: nil,
                                          repeats: true)
        self.timer?.fire()
    }
    
    @objc private func startTimer(_ timer: Timer) {
        self.callback?(timer.fireDate)
    }
    
    func cancel() {
        self.timer?.invalidate()
        self.timer = nil
        self.callback = nil
    }
}
