//
//  SDLapRepository.swift
//  Stopwatch
//
//  Created by alphacircle on 3/30/26.
//

import Foundation
import SwiftData

final class SDLapRepository: LapRepository {
    private let context: ModelContext
    private let mapper: SDLapMapper = SDLapMapper()
    
    init() {
        let container = try! ModelContainer(for: SDLap.self)
        let context = ModelContext(container)
        self.context = context
    }
    
    func create(_ lap: Lap, completion: @escaping ((any Error)?) -> Void) {
        let sdLap: SDLap = mapper.map(lap)
        context.insert(sdLap)
        completion(nil)
    }
    
    func read(completion: @escaping (Result<[Lap], any Error>) -> Void) {
        let descriptor = FetchDescriptor<SDLap>(sortBy: [SortDescriptor(\.id, order: SortOrder.reverse)])
        do {
            let laps: [Lap] = try context.fetch(descriptor)
                .map(mapper.map(_:))
            completion(Result.success(laps))
        } catch {
            completion(Result.failure(error))
        }
    }
    
    func delete(completion: @escaping ((any Error)?) -> Void) {
        do {
            try context.delete(model: SDLap.self)
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    private final class SDLapMapper {
        func map(_ lap: Lap) -> SDLap {
            return SDLap(number: lap.id,
                         split: lap.split,
                         total: lap.total,
                         progress: lap.progress)
        }
        
        func map(_ lap: SDLap) -> Lap {
            return Lap(number: lap.id,
                       split: lap.split,
                       total: lap.total,
                       progress: lap.progress)
        }
    }
}
