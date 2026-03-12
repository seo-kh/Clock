//
//  StartFlagService.swift
//  Stopwatch
//
//  Created by alphacircle on 3/12/26.
//

import Foundation

final class StartFlagService: SetStartFlagUseCase {
    private var updateStartFlagPort: UpdateStartFlagPort
    
    init(updateStartFlagPort: UpdateStartFlagPort) {
        self.updateStartFlagPort = updateStartFlagPort
    }
    
    func setFlag(command: SetStartFlagCommand) {
        updateStartFlagPort.update(command.flag)
    }
}
