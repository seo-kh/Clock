//
//  LapSwiftDataAdapter.swift
//  Stopwatch
//
//  Created by alphacircle on 3/11/26.
//

import Foundation
import SwiftData

final class LapSwiftDataAdapter {
    private var context: ModelContext?
    
    init() {
        self.context = nil
    }
}

extension LapSwiftDataAdapter: ResetLapPort {
    func reset() throws {
        try self.context?.delete(model: SDLap.self)
    }
}

extension LapSwiftDataAdapter: UpdateLapPort {
    func update(_ target: Lap) {
        let sdLap = SDLapMapper.mapToSDLap(from: target)
        self.context?.insert(sdLap)
    }
}

extension LapSwiftDataAdapter: LoadLapPort {
    func load(callback: @escaping (Result<[Lap], Error>) -> Void) {
        if (context == nil) {
            do {
                let container = try ModelContainer(for: SDLap.self)
                self.context = ModelContext(container)
            } catch {
                callback(.failure(error))
            }
        }
        
        /// id를 기준으로 역방향으로 정렬해서 Lap 데이터 가져오기
        let descriptor = FetchDescriptor<SDLap>(sortBy: [SortDescriptor(\.id, order: SortOrder.reverse)])
        do {
            let sdLaps = try context!.fetch(descriptor)
            let laps = sdLaps.map(SDLapMapper.mapToLap(from:))
            callback(Result.success(laps))
        } catch {
            callback(Result.failure(error))
        }
    }
    
    private enum SDLapMapper {
        @MainActor
        static func mapToLap(from sdLap: SDLap) -> Lap {
            Lap(number: sdLap.id, split: sdLap.split, total: sdLap.total, progress: sdLap.progress)
        }
        
        @MainActor
        static func mapToSDLap(from lap: Lap) -> SDLap {
            SDLap(number: lap.id,
                  split: lap.split,
                  total: lap.total,
                  progress: lap.progress)
        }
    }

}
