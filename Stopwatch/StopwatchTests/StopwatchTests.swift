//
//  StopwatchTests.swift
//  StopwatchTests
//
//  Created by alphacircle on 1/5/26.
//

import Testing
@testable import Stopwatch

struct StopwatchTests {

    @Test
    @MainActor
    func example() async throws {
        let sw = Stopwatch()
        sw.start()
        
        #expect(sw.laps.count == 1)
        try await Task.sleep(for: .seconds(5))
        sw.stop()
    }

}
