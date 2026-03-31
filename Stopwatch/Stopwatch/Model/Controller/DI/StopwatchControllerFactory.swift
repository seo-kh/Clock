//
//  StopwatchControllerFactory.swift
//  Stopwatch
//
//  Created by alphacircle on 3/31/26.
//

import Foundation

protocol StopwatchControllerFactory {
    func lapRepository() -> LapRepository
    func flagRepository() -> FlagRepository
    func timerSource() -> TimerSource
    func activationSource() -> AppActivationSource
}
