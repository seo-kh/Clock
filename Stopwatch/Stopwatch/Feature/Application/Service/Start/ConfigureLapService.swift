//
//  ConfigureLapService.swift
//  Stopwatch
//
//  Created by alphacircle on 3/12/26.
//

import Foundation

final class ConfigureLapService: ConfigureLapUseCase {
    private var updateLapPort: UpdateLapPort
    
    init(updateLapPort: UpdateLapPort) {
        self.updateLapPort = updateLapPort
    }
    
    func configureLaps(command: ConfigureLapCommand) {
        var laps = command.laps
        if laps.isEmpty {
            let now: Date = Date.now
            let newLap = Lap(number: 1, split: now, total: now, progress: now)
            laps.append(newLap)
            
            updateLapPort.update(newLap)
        } else {
            laps[0].adjust()
        }
        
        command.configLap(Result.success(laps))
    }
}
