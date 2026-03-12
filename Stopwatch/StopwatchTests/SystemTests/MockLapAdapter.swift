//
//  MockLapAdapter.swift
//  StopwatchTests
//
//  Created by alphacircle on 3/11/26.
//

import Foundation
@testable import Stopwatch

final class MockLapAdapter {
    var laps: [Lap]
    let error: Error?
    
    init(laps: [Lap], error: Error? = nil) {
        self.laps = laps
        self.error = error
    }
}

extension MockLapAdapter: UpdateLapPort {
    func update(_ target: Lap) {
        self.laps.insert(target, at: 0)
    }
}

extension MockLapAdapter: LoadLapPort {
    func load(callback: @escaping (Result<[Lap], Error>) -> Void) {
        if let error {
            callback(Result.failure(error))
        } else {
            callback(.success(laps))
        }
    }
}
