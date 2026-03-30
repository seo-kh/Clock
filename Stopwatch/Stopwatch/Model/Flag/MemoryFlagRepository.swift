//
//  MemoryFlagRepository.swift
//  Stopwatch
//
//  Created by alphacircle on 3/30/26.
//

import Foundation

final class MemoryFlagRepository: FlagRepository {
    private var flag: Bool
    
    init(flag: Bool) {
        self.flag = flag
    }
    
    func set(_ value: Bool, completion: @escaping ((any Error)?) -> Void) {
        self.flag = value
        completion(nil)
    }
    
    func get(completion: @escaping (Result<Bool, any Error>) -> Void) {
        completion(Result.success(self.flag))
    }
}
