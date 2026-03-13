//
//  ResetService.swift
//  Stopwatch
//
//  Created by alphacircle on 3/12/26.
//

import Foundation

final class ResetService: ResetLapUseCase {
    private var resetLapPort: ResetLapPort
    
    init(resetLapPort: ResetLapPort) {
        self.resetLapPort = resetLapPort
    }
    
    func reset() throws {
        try self.resetLapPort.reset()
    }
}
