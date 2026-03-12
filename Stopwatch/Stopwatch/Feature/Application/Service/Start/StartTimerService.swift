//
//  StartTimerService.swift
//  Stopwatch
//
//  Created by alphacircle on 3/12/26.
//

import Foundation

final class StartTimerService: StartTimerUseCase {
    private var resumeTimerPort: ResumeTimerPort
    
    init(resumeTimerPort: ResumeTimerPort) {
        self.resumeTimerPort = resumeTimerPort
    }
    
    func startTimer(command: StartTimerCommand) {
        self.resumeTimerPort.resume { date in
            command.configureProgress(date)
        }
    }
}
