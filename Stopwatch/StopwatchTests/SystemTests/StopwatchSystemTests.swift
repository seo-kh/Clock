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
    struct SystemBootTests {
        @Test("시스템 초기화 테스트")
        func test1() async throws {
            // Given
            let bootController = DIBootController.test1()
            
            // When
            let watch = _Stopwatch(bootController: bootController)
            
            // Then
            // watch mode 초기화
            #expect(watch.watchMode != nil)
            // Laps 초기화
            #expect(!watch.laps.isEmpty)
            // isActive 초기화
            #expect(watch.isActive)
            // Buttons 초기화
            #expect(!watch.components.isEmpty)
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
    
    @Test("시스템 취소 테스트")
    func test5() async throws {
        
    }
}
