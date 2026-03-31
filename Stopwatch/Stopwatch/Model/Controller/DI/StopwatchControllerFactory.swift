//
//  StopwatchControllerFactory.swift
//  Stopwatch
//
//  Created by alphacircle on 3/31/26.
//

import Foundation

protocol StopwatchControllerConfiguration {
    func lapRepository() -> LapRepository
    func flagRepository() -> FlagRepository
    func timerSource() -> TimerSource
    func activationSource() -> AppActivationSource
}
