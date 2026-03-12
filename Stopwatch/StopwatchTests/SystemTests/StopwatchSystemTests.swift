//
//  StopwatchSystemTests.swift
//  StopwatchTests
//
//  Created by alphacircle on 3/10/26.
//

import Testing
@testable import Stopwatch

struct StopwatchSystemTests {

    @Suite("System Boot Tests")
    @MainActor
    struct SystemBootTests {
        @Test("시스템 초기화 테스트")
        func test1() async throws {
            // Given
            let bootController = DIController.bootTest1()
            
            // When
            let watch = _Stopwatch(bootController: bootController, lapController: nil)
            
            // Then
            // Laps 초기화
            #expect(!watch.laps.isEmpty)
            // isActive 초기화
            #expect(watch.isActive)
            // Buttons 초기화
            #expect(!watch.components.isEmpty)
        }
    }
    
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
    @Suite("Start Lap Tests")
    struct LapTests {
        @Test("빈 laps에서, stopwatch가 lap()을 호출해도 크기는 변화없어야함")
        func test1() {
            // Given
            let ctrl = DIController.lapTest1()
            let stopwatch = _Stopwatch(bootController: ctrl, lapController: nil)
            // When
            #expect(stopwatch.laps.isEmpty)
            stopwatch.lap()
            // Then
            #expect(stopwatch.laps.isEmpty)
        }
        
        @Test("비어있지 않은 laps에서, stopwatch가 lap()을 호출한 횟수만큼 laps가 증가함")
        func test2() {
            // Given
            let (boot, lap) = DIController.lapTest2()
            let stopwatch = _Stopwatch(bootController: boot, lapController: lap)
            let count = stopwatch.laps.count
            // When
            let iter = 3
            for _ in 0..<iter { stopwatch.lap() }
            let newCount = stopwatch.laps.count
            // then
            #expect(newCount - count == iter)
        }
        
        @Test("lap 추가시, persistance layer에 lap update 시도해야함")
        func test3() {
            // Given
            let lap = MockLapAdapter(laps: [Lap.empty])
            let stopwatch = DIController.lapTest3(lap: lap)
            // When
            let iter = 5
            for _ in 0..<iter { stopwatch.lap() }
            // then
            #expect(lap.laps.count - iter == 1)
        }
        
        @Test("lap 추가시, watchMode가 true일때, off되어야함")
        func test4() {
            // Given
            let stopwatch = DIController.lapTest4()
            stopwatch.watchMode.change() // true
            #expect(stopwatch.watchMode.isActive)
            // When
            stopwatch.lap()
            // Then
            #expect(stopwatch.watchMode.isActive == false)
        }
    }

    @Test("시스템 시작 테스트")
    func test2() async throws {
        
    }
    
    @Test("시스템 중단 테스트")
    func test3() async throws {
        
    }
    
    @Test("시스템 취소 테스트")
    func test4() async throws {
        
    }
}
