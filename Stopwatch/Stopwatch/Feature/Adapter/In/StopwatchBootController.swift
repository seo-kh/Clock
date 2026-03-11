//
//  StopwatchBootController.swift
//  Stopwatch
//
//  Created by alphacircle on 3/11/26.
//

import Foundation

final class StopwatchBootController {
    private var useCase: StopwatchBootUseCase
    
    init(useCase: StopwatchBootUseCase) {
        self.useCase = useCase
    }

    func boot(target: StopwatchBootControllerDelegate) {
        let command = BootCommand(configLap: target.lap(_:),
                                  configMode: target.mode(_:),
                                  configLifecycle: target.lifecycle(_:))
        useCase.boot(command)
    }
}
