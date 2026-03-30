//
//  MemoryAppActivationSource.swift
//  Stopwatch
//
//  Created by alphacircle on 3/30/26.
//

import Foundation

final class MemoryAppActivationSource: AppActivationSource {
    private var isActivate: Bool
    
    init(isActivate: Bool) {
        self.isActivate = isActivate
    }
    
    func start(onUpdate: @escaping (Result<Bool, any Error>) -> Void) {
        onUpdate(Result.success(self.isActivate))
        self.isActivate.toggle()
    }
    
    func stop(completion: @escaping ((any Error)?) -> Void) {
        completion(nil)
    }
}
