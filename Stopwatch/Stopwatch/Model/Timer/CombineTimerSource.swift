//
//  CombineTimerSource.swift
//  Stopwatch
//
//  Created by alphacircle on 3/30/26.
//

import Foundation
import Combine

final class CombineTimerSource: TimerSource {
    private var cancellable: Cancellable?
    private let timeInterval: TimeInterval
    
    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    func start(onUpdate: @escaping (Result<Date, any Error>) -> Void) {
        cancellable = Timer.publish(every: timeInterval, on: .current, in: .common)
            .autoconnect()
            .sink(receiveValue: { date in
                onUpdate(Result.success(date))
            })
    }
    
    func stop(onCompletion: @escaping ((any Error)?) -> Void) {
        self.cancellable?.cancel()
        self.cancellable = nil
    }
}
