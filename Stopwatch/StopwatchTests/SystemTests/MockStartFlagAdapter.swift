//
//  MockStartFlagAdapter.swift
//  StopwatchTests
//
//  Created by alphacircle on 3/11/26.
//

import Foundation
@testable import Stopwatch

final class MockStartFlagAdapter {
    var isActive: Bool
    
    init(isActive: Bool) {
        self.isActive = isActive
    }
    
}

extension MockStartFlagAdapter: UpdateStartFlagPort {
    func update(_ flag: Bool) {
        self.isActive = flag
    }
}

extension MockStartFlagAdapter: LoadStartFlagPort {
    func load(callback: @escaping (Bool) -> Void) {
        callback(isActive)
    }
}
