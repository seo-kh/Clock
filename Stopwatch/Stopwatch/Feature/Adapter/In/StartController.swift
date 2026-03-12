//
//  StartController.swift
//  Stopwatch
//
//  Created by alphacircle on 3/12/26.
//

import Foundation

final class StartController {
    private var configureLapUseCase: ConfigureLapUseCase?
    private var startTimerUseCase: StartTimerUseCase?
    private var setStartFlagUseCase: SetStartFlagUseCase?
    
    init(configureLapUseCase: ConfigureLapUseCase?, startTimerUseCase: StartTimerUseCase?, setStartFlagUseCase: SetStartFlagUseCase?) {
        self.configureLapUseCase = configureLapUseCase
        self.startTimerUseCase = startTimerUseCase
        self.setStartFlagUseCase = setStartFlagUseCase
    }
    
    func configureLaps(_ current: [Lap], target: StopwatchControllerDelegate) {
        let command = ConfigureLapCommand(laps: current, configLap: target.didLoadLaps(_:))
        configureLapUseCase?.configureLaps(command: command)
    }
    
    func startTimer(target: StopwatchControllerDelegate) {
        let command = StartTimerCommand(configureProgress: target.didChangeProgress(_:))
        startTimerUseCase?.startTimer(command: command)
    }
    
    func enableStartFlag() {
        let command = SetStartFlagCommand(flag: true)
        setStartFlagUseCase?.setFlag(command: command)
    }
}
