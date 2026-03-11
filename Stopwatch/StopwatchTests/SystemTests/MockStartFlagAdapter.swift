//
//  MockStartFlagAdapter.swift
//  StopwatchTests
//
//  Created by alphacircle on 3/11/26.
//

import Foundation
@testable import Stopwatch

final class MockStartFlagAdapter: LoadStartFlagPort {
    let isActive: Bool
    
    init(isActive: Bool) {
        self.isActive = isActive
    }
    
    func load(callback: @escaping (Bool) -> Void) {
        callback(isActive)
    }
}
