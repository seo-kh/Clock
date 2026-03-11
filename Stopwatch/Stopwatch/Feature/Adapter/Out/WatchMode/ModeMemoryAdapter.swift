//
//  ModeMemoryAdapter.swift
//  Stopwatch
//
//  Created by alphacircle on 3/11/26.
//

import Foundation

final class ModeMemoryAdapter: LoadModePort, UpdateModePort {
    private var isActive: Bool
    
    init(isActive: Bool = false) {
        self.isActive = isActive
    }
    
    func load(callback: @escaping (WatchMode) -> Void) {
        let mode = WatchMode(isActive: isActive, change: {})
        callback(mode)
    }
    
    func update(_ mode: WatchMode) {
        self.isActive = mode.isActive
    }
}
