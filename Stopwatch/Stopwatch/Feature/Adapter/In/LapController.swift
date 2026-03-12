//
//  LapController.swift
//  Stopwatch
//
//  Created by alphacircle on 3/12/26.
//

import Foundation

final class LapController {
    private var lapUseCase: LapUseCase
    
    init(lapUseCase: LapUseCase) {
        self.lapUseCase = lapUseCase
    }
    
    func lap(_ source: Lap, target: StopwatchControllerDelegate) {
        let command = LapCommand(source: source, configNewLap: target.didAddLap(_:))
        self.lapUseCase.lap(command: command)
    }
}
