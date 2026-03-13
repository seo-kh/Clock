//
//  DIService.swift
//  StopwatchTests
//
//  Created by alphacircle on 3/13/26.
//

import Foundation
@testable import Stopwatch

@MainActor
enum DIService {
    static func testBoot1() -> BootService {
        // out port
        let flag = MockStartFlagAdapter(isActive: false)
        let lap = MockLapAdapter(laps: [])
        let lifecycle = MockLifecycleAdapter(isActive: true)
        
        // service
        let service = BootService(loadStartFlagPort: flag,
                                  loadLapPort: lap,
                                  lifecyclePort: lifecycle)
        return service
    }
    
    static func testLap1() -> LapService {
        // out port
        let lap = MockLapAdapter(laps: [])
        
        // service
        let service = LapService(updateLapPort: lap)
        
        return service
    }
    
    static func testLap2(_ port: UpdateLapPort) -> LapService {
        // service
        let service = LapService(updateLapPort: port)
        
        return service
    }
    
    static func testStart1() -> StartService {
        // out port
        let timer = LocalTimer(0.03)
        let flag = MockStartFlagAdapter(isActive: false)
        let lap = MockLapAdapter(laps: [])
        
        // service
        let service = StartService(resumeTimerPort: timer,
                                   updateStartFlagPort: flag,
                                   updateLapPort: lap)
        
        return service
    }
    
    static func testStart2() -> StartService {
        // out port
        let timer = LocalTimer(0.03)
        let flag = MockStartFlagAdapter(isActive: false)
        let lap = MockLapAdapter(laps: [Lap.empty])
        
        // service
        let service = StartService(resumeTimerPort: timer,
                                   updateStartFlagPort: flag,
                                   updateLapPort: lap)
        
        return service
    }
    
    static func testStart3(flag: UpdateStartFlagPort) -> StartService {
        // out port
        let timer = LocalTimer(0.03)
        let lap = MockLapAdapter(laps: [Lap.empty])
        
        // service
        let service = StartService(resumeTimerPort: timer,
                                   updateStartFlagPort: flag,
                                   updateLapPort: lap)
        
        return service
    }
    
    static func testStop1(flag: UpdateStartFlagPort) -> StopService {
        // out port
        let timer = LocalTimer(0.03)
        
        // service
        let service = StopService(cancelTimerPort: timer,
                                  updateStartFlagPort: flag)
        
        return service
    }
}
