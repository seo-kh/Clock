//
//  BootController.swift
//  Stopwatch
//
//  Created by alphacircle on 3/11/26.
//

import Foundation

final class BootController {
    private var loadLapUseCase: LoadLapUseCase
    private var loadStartFlagUseCase: LoadStartFlagUseCase
    private var updateLifecycleUseCase: UpdateLifecycleUseCase
    
    init(
         loadLapUseCase: LoadLapUseCase,
         loadStartFlagUseCase: LoadStartFlagUseCase,
         updateLifecycleUseCase: UpdateLifecycleUseCase
    ) {
        self.loadLapUseCase = loadLapUseCase
        self.loadStartFlagUseCase = loadStartFlagUseCase
        self.updateLifecycleUseCase = updateLifecycleUseCase
    }
    
    func loadLaps(callback: @escaping (Result<[Lap], Error>) -> Void) {
        let command = LoadLapCommand(configureLaps: callback)
        loadLapUseCase.loadLap(command: command)
    }
    
    func loadStartFlag(callback: @escaping (Bool) -> Void) {
        let command = LoadStartFlagCommand(configureStartFlag: callback)
        loadStartFlagUseCase.loadStartFlag(command: command)
    }
    
    func updateLifecycle(callback: @escaping (Bool) -> Void) {
        let command = UpdateLifecycleCommand(configureLifecycle: callback)
        updateLifecycleUseCase.updateLifecycle(command: command)
    }
}
