//
//  LapService.swift
//  Stopwatch
//
//  Created by alphacircle on 3/12/26.
//

import Foundation

final class LapService {
    private let updateLapPort: UpdateLapPort
    
    init(updateLapPort: UpdateLapPort) {
        self.updateLapPort = updateLapPort
    }
}

extension LapService: LapUseCase {
    func lap(command: LapCommand) {
        let laps = command.source
        
        // lap이 없으면 그냥 종료
        guard let firstLap = laps.first else { return }
        
        // new lap 생성
        let newLap: Lap = firstLap.next()
        
        // 새로운 lap 알림
        command.configNewLap(newLap)
        
        // persistance에 전달
        updateLapPort.update(newLap)
    }
}

extension LapService: ConfigureLapUseCase {
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
