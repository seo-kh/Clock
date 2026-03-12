//
//  LocalTimerUnitTests.swift
//  StopwatchTests
//
//  Created by alphacircle on 3/10/26.
//

import Testing
import Foundation
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
        let pivot = Date.now
        var _date = Date.now
        
        // when
        await timer.resume { date in
            _date = date
        }
        
        try? await Task.sleep(for: .seconds(timeout))
        
        await timer.cancel()
        
        // then
        #expect((timeout - tolerance) < _date - pivot)
        #expect(_date - pivot < (timeout + tolerance))
    }

}
