//
//  MockModeAdapter.swift
//  StopwatchTests
//
//  Created by alphacircle on 3/11/26.
//

import Foundation
@testable import Stopwatch

final class MockModeAdapter: LoadModePort {
    let isActive: Bool
    
    init(isActive: Bool) {
        self.isActive = isActive
    }
    
    func load(callback: @escaping (WatchMode) -> Void) {
        let mode = WatchMode(isActive: isActive, change: {})
        callback(mode)
    }
}
