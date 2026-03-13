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
        guard let firstLap = laps.first else {
            command.configNewLap(nil)
            return
        }
        
        // new lap 생성
        let newLap: Lap = firstLap.next()
        
        // 새로운 lap 알림
        command.configNewLap(newLap)
        
        // persistance에 전달
        updateLapPort.update(newLap)
    }
}

