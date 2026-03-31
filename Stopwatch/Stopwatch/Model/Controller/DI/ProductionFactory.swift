//
//  ProductionFactory.swift
//  Stopwatch
//
//  Created by alphacircle on 3/31/26.
//

import Foundation

struct ProductionConfiguration: StopwatchControllerConfiguration {
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

extension StopwatchControllerConfiguration where Self == ProductionConfiguration {
    static var production: Self {
        Self()
    }
}
