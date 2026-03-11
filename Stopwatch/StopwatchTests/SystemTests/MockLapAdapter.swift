//
//  MockLapAdapter.swift
//  StopwatchTests
//
//  Created by alphacircle on 3/11/26.
//

import Foundation
@testable import Stopwatch

final class MockLapAdapter: LoadLapPort {
    let laps: [Lap]
    let error: Error?
    
    init(laps: [Lap], error: Error? = nil) {
        self.laps = laps
        self.error = error
    }
    
    func load(callback: @escaping (Result<[Lap], Error>) -> Void) {
        if let error {
            callback(Result.failure(error))
        } else {
            callback(.success(laps))
        }
    }
}
