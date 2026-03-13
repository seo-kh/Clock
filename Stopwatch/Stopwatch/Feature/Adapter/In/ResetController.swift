//
//  ResetController.swift
//  Stopwatch
//
//  Created by alphacircle on 3/12/26.
//

import Foundation

final class ResetController {
    private var resetLapUseCase: ResetLapUseCase
    
    init(resetLapUseCase: ResetLapUseCase) {
        self.resetLapUseCase = resetLapUseCase
    }
    
    func resetLaps() throws {
        try resetLapUseCase.reset()
    }
}
