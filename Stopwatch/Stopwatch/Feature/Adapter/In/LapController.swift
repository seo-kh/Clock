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
    
    func lap(at source: [Lap], callback: @escaping (Lap) -> Void) {
        let command = LapCommand(source: source, configNewLap: callback)
        self.lapUseCase.lap(command: command)
    }
}
