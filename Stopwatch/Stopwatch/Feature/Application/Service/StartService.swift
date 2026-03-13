//
//  StartService.swift
//  Stopwatch
//
//  Created by alphacircle on 3/12/26.
//

import Foundation

final class StartService {
    private var resumeTimerPort: ResumeTimerPort
    private var updateStartFlagPort: UpdateStartFlagPort
    private var updateLapPort: UpdateLapPort
    
    init(resumeTimerPort: ResumeTimerPort,
         updateStartFlagPort: UpdateStartFlagPort,
         updateLapPort: UpdateLapPort
    ) {
        self.resumeTimerPort = resumeTimerPort
        self.updateStartFlagPort = updateStartFlagPort
        self.updateLapPort = updateLapPort
    }
}

extension StartService: SetStartFlagUseCase {
    func setFlag(command: SetStartFlagCommand) {
        updateStartFlagPort.update(command.flag)
    }
}

extension StartService: StartTimerUseCase {
    func startTimer(command: StartTimerCommand) {
        self.resumeTimerPort.resume { date in
            command.configureProgress(date)
        }
    }
}

extension StartService: ConfigureLapUseCase {
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
