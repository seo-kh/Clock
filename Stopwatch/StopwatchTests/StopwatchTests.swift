//
//  StopwatchTests.swift
//  StopwatchTests
//
//  Created by alphacircle on 1/5/26.
//

import Testing
@testable import Stopwatch

@MainActor
struct StopwatchTests {
    
    private func delay(_ seconds: Int) async throws {
        try await Task.sleep(for: .seconds(seconds))
    }
    
    @Test("check: laps are empty")
    func test1() async throws {
        // given
        let stopwatch = Stopwatch()
        
        #expect(stopwatch.laps.isEmpty)
    }

    @Test("check: lap count is only one after start")
    func test2() async throws {
        // given
        let stopwatch = Stopwatch()
        
        // when: start button action
        stopwatch.components[1].action?()
        try await delay(1)
        
        #expect(stopwatch.laps.count == 1)
    }

    @Test("check: split time interval is 3 sec")
    func test3() async throws {
        // given
        let stopwatch = Stopwatch()
        
        // when
        stopwatch.components[1].action?() // start
        try await delay(1)
        stopwatch.components[1].action?() // stop
        stopwatch.components[1].action?() // start
        try await delay(2)
        stopwatch.components[1].action?() // stop

        // then
        let lap = try #require(stopwatch.laps.first)
        let timeInterval = lap.progress - lap.total
        #expect((3.0 ..< 3.1).contains(timeInterval))
    }
    
    @Test("check: lap count after presseing lap button 5 times when init")
    func test4() async throws {
        // given
        let stopwatch = Stopwatch()
        
        // when
        stopwatch.components[0].action?() // lap
        stopwatch.components[0].action?() // lap
        stopwatch.components[0].action?() // lap
        stopwatch.components[0].action?() // lap
        stopwatch.components[0].action?() // lap

        // then
        #expect(stopwatch.laps.isEmpty)
    }
    
    @Test("check: lap count after presseing lap button 5 times when start")
    func test5() async throws {
        // given
        let stopwatch = Stopwatch()
        
        // when
        stopwatch.components[1].action?() // start
        
        for i in 1...5 {
            try await delay(1)
            stopwatch.components[0].action?() // lap
            print("\(i) sec...")
        }
        
        stopwatch.components[1].action?() // stop

        // then
        #expect(stopwatch.laps.count == 6) // test 1
        
        let lap = try #require(stopwatch.laps.first)
        let timeInterval = lap.progress - lap.total
        #expect((4.95 ..< 5.05).contains(timeInterval)) // test 2
        
    }
    
    @Test("check: lap count after presseing any button during 5 sec")
    func test6() async throws {
        // given
        let stopwatch = Stopwatch()
        
        // when
        stopwatch.components[0].action?() // lap(disable)
        try await delay(1)
        stopwatch.components[1].action?() // start
        try await delay(1)
        stopwatch.components[0].action?() // lap
        try await delay(1)
        stopwatch.components[1].action?() // stop
        try await delay(1)
        stopwatch.components[0].action?() // reset
        try await delay(1)

        // then
        #expect(stopwatch.laps.count == 0) // test 1
    }
}
