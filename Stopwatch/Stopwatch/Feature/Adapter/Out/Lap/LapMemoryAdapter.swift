//
//  LapMemoryAdapter.swift
//  Stopwatch
//
//  Created by alphacircle on 3/11/26.
//

import Foundation

final class LapMemoryAdapter: LoadLapPort {
    private var laps: [Lap] = []
    
    func load(callback: @escaping (Result<[Lap], Error>) -> Void) {
        callback(.success(laps))
    }
}
