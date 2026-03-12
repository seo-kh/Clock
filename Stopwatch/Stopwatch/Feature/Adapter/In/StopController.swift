//
//  StopController.swift
//  Stopwatch
//
//  Created by alphacircle on 3/12/26.
//

import Foundation

final class StopController {
    private var stopTimerUseCase: StopTimerUseCase
    private var setStartFlagUseCase: SetStartFlagUseCase
    
    init(stopTimerUseCase: StopTimerUseCase, setStartFlagUseCase: SetStartFlagUseCase) {
        self.stopTimerUseCase = stopTimerUseCase
        self.setStartFlagUseCase = setStartFlagUseCase
    }
    
    func stopTimer() {
        let command = StopTimerCommand()
        stopTimerUseCase.stopTimer(command: command)
    }
    
    func disableStartFlag() {
        let command = SetStartFlagCommand(flag: false)
        self.setStartFlagUseCase.setFlag(command: command)
    }
}
