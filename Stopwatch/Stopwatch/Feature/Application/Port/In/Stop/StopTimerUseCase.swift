//
//  StopTimerUseCase.swift
//  Stopwatch
//
//  Created by alphacircle on 3/12/26.
//

import Foundation

protocol StopTimerUseCase {
    func stopTimer(command: StopTimerCommand)
}
