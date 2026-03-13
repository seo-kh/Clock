//
//  StopwatchSystemTests.swift
//  StopwatchTests
//
//  Created by alphacircle on 3/10/26.
//

import Testing
import Foundation
@testable import Stopwatch

struct StopwatchSystemTests {
    /*
     test 항목
     1. Lap 추가
     2. watchMode가 활성화 되어있을때, 모드 전환하기
     
     * 상세
     - Lap 추가
     1. laps의 첫번째 요소를 이용해서 next()를 호출해서 다음 lap을 생성
     2. laps의 첫번째 요소칸으로 insert
     3. persistance 데이터에 추가
     
     만약, laps의 첫번째 요소가 없다면?
     laps가 배열이 아닌 다른 자료구조라면?
     */
    @MainActor
    @Suite("System Lap Tests")
    struct SystemLapTests {
        @Test("빈 laps에서, stopwatch가 lap()을 호출해도 크기는 변화없어야함")
        func test1() {
            // Given
            let stopwatch = DISystem.lapTest1()
            // When
            #expect(stopwatch.laps.isEmpty)
            stopwatch.lap()
            // Then
            #expect(stopwatch.laps.isEmpty)
        }
        
        @Test("비어있지 않은 laps에서, stopwatch가 lap()을 호출한 횟수만큼 laps가 증가함", arguments: [3, 5, 10])
        func test2(iter: Int) {
            // Given
            let stopwatch = DISystem.lapTest2()
            // When
            let count = stopwatch.laps.count
            for _ in 0..<iter { stopwatch.lap() }
            let newCount = stopwatch.laps.count
            // then
            #expect(newCount - count == iter)
        }
        
        // macOS 전용 기능임.. 추후 멀티 플렛폼 지원시 고려해야함
        @Test("lap 추가시, watchMode가 true일때, off되어야함")
        func test3() {
            // Given
            let stopwatch = DISystem.lapTest3()
            #expect(stopwatch.watchMode.isActive)
            // When
            stopwatch.lap()
            // Then
            #expect(stopwatch.watchMode.isActive == false)
        }
    }

    @MainActor
    @Suite("System Start Tests")
    struct SystemStartTests {
        @Test("timer 시작: 5초후 중단 그리고 split기록 확인")
        func test1() async throws {
            // Given
            let stopwatch = DISystem.startTest1()
            #expect(stopwatch.laps.isEmpty == false)
            // When
            stopwatch.start()
            
            try await Task.sleep(for: .seconds(5))
            // Then
            let afterStart = stopwatch.laps.first!
            let interval = afterStart.progress - afterStart.total
            #expect(interval > 5.0 - 0.5)
        }
    }
    
    @MainActor
    @Suite("System Stop Tests")
    struct SystemStopTests {
        @Test("타이머가 멈췄는지 테스트", arguments: [3.0, 5.0])
        func test1(timeout: Double) async throws {
            // Given
            let stopwatch = DISystem.stopTest1()
            // When
            stopwatch.start()
            try await Task.sleep(for: .seconds(timeout))
            stopwatch.stop()
            // Then
            let lap = stopwatch.laps.first!
            let interval = lap.progress - lap.total
            #expect(timeout - 0.1 < interval)
            #expect(interval < timeout + 0.1)
        }
        
        @Test("실행, 중단 반복 테스트")
        func test2() async throws {
            // Given
            let stopwatch = DISystem.stopTest2()
            // When
            stopwatch.start()
            try await Task.sleep(for: .seconds(3.0))
            stopwatch.stop()
            try await Task.sleep(for: .seconds(0.5))
            stopwatch.start()
            try await Task.sleep(for: .seconds(3.0))
            stopwatch.stop()
            try await Task.sleep(for: .seconds(0.5))
            stopwatch.start()
            try await Task.sleep(for: .seconds(3.0))
            stopwatch.stop()
            try await Task.sleep(for: .seconds(0.5))
            stopwatch.start()
            try await Task.sleep(for: .seconds(1.0))
            stopwatch.stop()
            // Then
            let lap = stopwatch.laps.first!
            let interval = lap.progress - lap.total
            #expect(10.0 - 0.1 < interval)
            #expect(interval < 10.0 + 0.1)
        }
    }
    
    @MainActor
    @Suite("System Reset Tests")
    struct SystemResetTests {
        @Test("시스템 취소 테스트: laps는 empty")
        func test1() async throws {
            // Given
            let stopwatch = DISystem.resetTest1()
            // When
            stopwatch.start()
            try await Task.sleep(for: .seconds(2))
            stopwatch.stop()
            try await Task.sleep(for: .seconds(2))
            stopwatch.start()
            for _ in 0..<3 {
                stopwatch.lap()
                try await Task.sleep(for: .seconds(1.0))
            }
            #expect(stopwatch.laps.isEmpty == false)
            stopwatch.reset()
            // Then
            #expect(stopwatch.laps.isEmpty == true)
        }
    }
}
