//
//  StopTimerService.swift
//  Stopwatch
//
//  Created by alphacircle on 3/12/26.
//

import Foundation

final class StopTimerService: StopTimerUseCase {
    var cancelTimerPort: CancelTimerPort
    
    init(cancelTimerPort: CancelTimerPort) {
        self.cancelTimerPort = cancelTimerPort
    }
    
    func stopTimer(command: StopTimerCommand) {
        self.cancelTimerPort.cancel()
    }
}
