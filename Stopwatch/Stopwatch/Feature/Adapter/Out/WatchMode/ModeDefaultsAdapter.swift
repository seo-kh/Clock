//
//  ModeDefaultsAdapter.swift
//  Stopwatch
//
//  Created by alphacircle on 3/11/26.
//

import Foundation

final class ModeDefaultsAdapter: LoadModePort, UpdateModePort {
    private let userDefaults: UserDefaults
    private static let defaultKey: String = "isRunnig"
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    convenience init() {
        self.init(userDefaults: UserDefaults())
    }
    
    func load(callback: @escaping (WatchMode) -> Void) {
        let value = self.userDefaults.bool(forKey: Self.defaultKey)
        let mode = WatchMode(isActive: value, change: {})
        callback(mode)
    }
    
    func update(_ mode: WatchMode) {
        let value = mode.isActive
        self.userDefaults.set(value, forKey: Self.defaultKey)
    }
}
