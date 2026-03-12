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
    
    func configureLaps(_ current: [Lap], callback: @escaping (Result<[Lap], Error>) -> Void) {
        let command = ConfigureLapCommand(laps: current, configLap: callback)
        configureLapUseCase?.configureLaps(command: command)
    }
    
    func startTimer(callback: @escaping (Date) -> Void) {
        let command = StartTimerCommand(configureProgress: callback)
        startTimerUseCase?.startTimer(command: command)
    }
    
    func enableStartFlag() {
        let command = SetStartFlagCommand(flag: true)
        setStartFlagUseCase?.setFlag(command: command)
    }
}
