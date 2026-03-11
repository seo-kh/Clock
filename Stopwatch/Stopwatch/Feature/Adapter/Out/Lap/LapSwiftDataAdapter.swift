//
//  LapSwiftDataAdapter.swift
//  Stopwatch
//
//  Created by alphacircle on 3/11/26.
//

import Foundation
import SwiftData

final class LapSwiftDataAdapter: LoadLapPort {
    private var context: ModelContext?
    
    init() {
        self.context = nil
    }
    
    func load(callback: @escaping (Result<[Lap], Error>) -> Void) {
        if (context == nil) {
            do {
                let container = try ModelContainer(for: Lap.self)
                self.context = ModelContext(container)
            } catch {
                callback(.failure(error))
            }
        }
        
        /// id를 기준으로 역방향으로 정렬해서 Lap 데이터 가져오기
        let descriptor = FetchDescriptor<Lap>(sortBy: [SortDescriptor(\.id, order: SortOrder.reverse)])
        do {
            let laps = try context!.fetch(descriptor)
            callback(Result.success(laps))
        } catch {
            callback(Result.failure(error))
        }
    }
}
