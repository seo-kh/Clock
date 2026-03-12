//
//  BootController.swift
//  Stopwatch
//
//  Created by alphacircle on 3/11/26.
//

import Foundation

final class BootController {
    private var useCase: BootUseCase
    
    init(useCase: BootUseCase) {
        self.useCase = useCase
    }

    func boot(target: StopwatchControllerDelegate) {
        let command = BootCommand(configLap: target.didLoadLaps(_:),
                                  configStartFlag: target.didChangeStartFlag(_:),
                                  configLifecycle: target.didChangeLifecycle(_:))
        useCase.boot(command)
    }
}
