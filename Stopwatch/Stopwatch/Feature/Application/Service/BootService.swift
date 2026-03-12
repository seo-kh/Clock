//
//  BootService.swift
//  Stopwatch
//
//  Created by alphacircle on 3/11/26.
//

import Foundation

final class BootService: BootUseCase {
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
    
    func boot(_ command: BootCommand) {
        self.loadLapPort.load { result in
            command.configLap(result)
        }
        
        self.lifecyclePort.listen { result in
            command.configLifecycle(result)
        }
        
        self.loadStartFlagPort.load { result in
            command.configStartFlag(result)
        }
    }
}
