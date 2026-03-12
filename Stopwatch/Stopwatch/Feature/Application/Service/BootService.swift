//
//  BootService.swift
//  Stopwatch
//
//  Created by alphacircle on 3/11/26.
//

import Foundation

final class BootService: LoadLapUseCase, LoadStartFlagUseCase, UpdateLifecycleUseCase {
    private var loadStartFlagPort: LoadStartFlagPort
    private var loadLapPort: LoadLapPort
    private var lifecyclePort: ListenLifecyclePort
    
    init(loadStartFlagPort: LoadStartFlagPort,
         loadLapPort: LoadLapPort,
         lifecyclePort: ListenLifecyclePort) {
        self.loadStartFlagPort = loadStartFlagPort
        self.loadLapPort = loadLapPort
        self.lifecyclePort = lifecyclePort
    }
    
    func loadLap(command: LoadLapCommand) {
        self.loadLapPort.load { result in
            command.configureLaps(result)
        }
    }
    
    func loadStartFlag(command: LoadStartFlagCommand) {
        self.loadStartFlagPort.load { result in
            command.configureStartFlag(result)
        }
    }
    
    func updateLifecycle(command: UpdateLifecycleCommand) {
        self.lifecyclePort.listen { result in
            command.configureLifecycle(result)
        }
    }
}
