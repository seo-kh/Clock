//
//  LapService.swift
//  Stopwatch
//
//  Created by alphacircle on 3/12/26.
//

import Foundation

final class LapService: LapUseCase {
    private let updateLapPort: UpdateLapPort
    
    init(updateLapPort: UpdateLapPort) {
        self.updateLapPort = updateLapPort
    }
    
    func lap(command: LapCommand) {
        // new lap 생성
        let newLap: Lap = command.source.next()
        
        // 새로운 lap 알림
        command.configNewLap(newLap)
        
        // persistance에 전달
        updateLapPort.update(newLap)
    }
}
