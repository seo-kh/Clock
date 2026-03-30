//
//  MemoryLapRepository.swift
//  Stopwatch
//
//  Created by alphacircle on 3/30/26.
//

import Foundation

final class MemoryLapRepository: LapRepository {
    private var laps: [Lap] = []
    
    func create(_ lap: Lap, completion: @escaping ((any Error)?) -> Void) {
        self.laps.insert(lap, at: 0)
        completion(nil)
    }
    
    func read(completion: @escaping (Result<[Lap], any Error>) -> Void) {
        completion(Result.success(self.laps))
    }
    
    func delete(completion: @escaping ((any Error)?) -> Void) {
        self.laps.removeAll()
        completion(nil)
    }
}
