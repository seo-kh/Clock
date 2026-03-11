//
//  MockLifecycleAdapter.swift
//  StopwatchTests
//
//  Created by alphacircle on 3/11/26.
//

import Foundation
@testable import Stopwatch

final class MockLifecycleAdapter: ListenLifecyclePort {
    let isActive: Bool
    
    init(isActive: Bool) {
        self.isActive = isActive
    }
    
    func listen(callback: @escaping (Bool) -> Void) {
        callback(isActive)
    }
}
