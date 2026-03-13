//
//  StopService.swift
//  Stopwatch
//
//  Created by alphacircle on 3/12/26.
//

import Foundation

final class StopService {
    private var cancelTimerPort: CancelTimerPort
    private var updateStartFlagPort: UpdateStartFlagPort
    
    init(cancelTimerPort: CancelTimerPort,
         updateStartFlagPort: UpdateStartFlagPort
    ) {
        self.cancelTimerPort = cancelTimerPort
        self.updateStartFlagPort = updateStartFlagPort
    }
}

extension StopService: SetStartFlagUseCase {
    func setFlag(command: SetStartFlagCommand) {
        self.updateStartFlagPort.update(command.flag)
    }
}

extension StopService: StopTimerUseCase {
    func stopTimer(command: StopTimerCommand) {
        self.cancelTimerPort.cancel()
    }
}
