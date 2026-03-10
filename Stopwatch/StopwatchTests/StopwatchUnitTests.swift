//
//  StopwatchUnitTests.swift
//  StopwatchTests
//
//  Created by alphacircle on 3/10/26.
//

import Testing
@testable import Stopwatch


@Suite("LocalTimer Unit Tests")
struct LocalTimerUnitTests {
    /// 오차범위 테스트
    ///
    /// timeout - tolerance < _interval < timeout + tolerance
    @Test("LocalTimer 시작 테스트: 설정한 시간만큼 오차범위 내에서 타이머가 동작했는지", arguments: [2.0, 5.0])
    func test1(timeout: Double) async throws {
        // given
        let timer = await LocalTimer(0.03)
        let tolerance = 0.1
        var _interval = 0.0
        
        // when
        await timer.resume { interval in
            _interval = interval
        }
        
        try? await Task.sleep(for: .seconds(timeout))
        
        await timer.cancel()
        
        // then
        #expect((timeout - tolerance) < _interval)
        #expect(_interval < (timeout + tolerance))
    }
    
    @Test("중단 재개 테스트")
    func test2() async throws {
        // given
        var intervals = [0.0, 0.0]
        let timer = await LocalTimer(0.03)
        let tolerance = 0.03
        let timeout = 2.0
        
        // when
        for idx in intervals.indices {
            await timer.resume { interval in
                intervals[idx] = interval
            }
            
            try? await Task.sleep(for: .seconds(timeout))
            
            await timer.cancel()
        }
        
        // then
        #expect(abs(intervals[0] - intervals[1]) < tolerance)
    }
}
