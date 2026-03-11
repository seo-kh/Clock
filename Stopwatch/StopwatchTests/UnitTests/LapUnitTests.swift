//
//  LapUnitTests.swift
//  StopwatchTests
//
//  Created by alphacircle on 3/10/26.
//

import Testing
import Foundation
@testable import Stopwatch

struct LapUnitTests {
    @Test("Lap 비교 연산자 테스트")
    @MainActor
    func test1() {
        // Given
        let lap1 = Lap(number: 1, split: .now.addingTimeInterval(3.0), total: .now, progress: .now)
        let lap2 = Lap(number: 1, split: .now.addingTimeInterval(6.0), total: .now, progress: .now)
        // When
        let result = lap1 > lap2
        // Then
        #expect(result)
    }
    
    @Test("Lap.next() 함수 테스트")
    func test2() {
        // Given
        let lap1 = Lap(number: 1, split: .now, total: .now, progress: .now + 40.0)
        // When
        let lap2 = lap1.next()
        // Then
        #expect(lap1.id < lap2.id)
        #expect(lap2.split - lap2.progress < 0.001)
        #expect(lap2.progress - lap2.total > 40.0 - 0.01)
    }
}
