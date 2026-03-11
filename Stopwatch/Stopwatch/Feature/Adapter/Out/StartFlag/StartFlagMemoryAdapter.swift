//
//  StartFlagMemoryAdapter.swift
//  Stopwatch
//
//  Created by alphacircle on 3/11/26.
//

import Foundation

final class StartFlagMemoryAdapter: LoadStartFlagPort, UpdateStartFlagPort {
    private var flag: Bool
    
    init(flag: Bool = false) {
        self.flag = flag
    }
    
    func load(callback: @escaping (Bool) -> Void) {
        callback(flag)
    }
    
    func update(_ flag: Bool) {
        self.flag = flag
    }
}
