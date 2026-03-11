//
//  StopwatchBootService.swift
//  Stopwatch
//
//  Created by alphacircle on 3/11/26.
//

import Foundation

final class StopwatchBootService: StopwatchBootUseCase {
    private var loadModePort: LoadModePort!
    private var loadLapPort: LoadLapPort!
    private var lifecyclePort: ListenLifecyclePort!
    
    init(loadModePort: LoadModePort,
         loadLapPort: LoadLapPort!,
         lifecyclePort: ListenLifecyclePort) {
        self.loadModePort = loadModePort
        self.loadLapPort = loadLapPort
        self.lifecyclePort = lifecyclePort
    }
    
    func boot(_ command: BootCommand) {
        self.loadLapPort.load { result in
            command.configLap(result)
        }
        
        self.lifecyclePort.listen { result in
            command.configLifecycle(result)
        }
        
        self.loadModePort.load { result in
            command.configMode(result)
        }
    }
}
