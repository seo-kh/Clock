//
//  LapMemoryAdapter.swift
//  Stopwatch
//
//  Created by alphacircle on 3/11/26.
//

import Foundation

final class LapMemoryAdapter {
    private var laps: [Lap] = []
    
}

extension LapMemoryAdapter: ResetLapPort {
    func reset() throws {
        self.laps.removeAll()
    }
}

extension LapMemoryAdapter: UpdateLapPort {
    func update(_ target: Lap) {
        self.laps.insert(target, at: 0)
    }
}

extension LapMemoryAdapter: LoadLapPort {
    func load(callback: @escaping (Result<[Lap], Error>) -> Void) {
        callback(.success(laps))
    }
}
