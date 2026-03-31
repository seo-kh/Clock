//
//  ProductionFactory.swift
//  Stopwatch
//
//  Created by alphacircle on 3/31/26.
//

import Foundation

final class ProductionFactory: StopwatchControllerFactory {
    func lapRepository() -> any LapRepository {
        SDLapRepository()
    }
    
    func flagRepository() -> any FlagRepository {
        UserDefaultsFlagRepository()
    }
    
    func timerSource() -> any TimerSource {
        CombineTimerSource(timeInterval: 0.003)
    }
    
    func activationSource() -> any AppActivationSource {
        NotificationAppActivationSource()
    }
}

