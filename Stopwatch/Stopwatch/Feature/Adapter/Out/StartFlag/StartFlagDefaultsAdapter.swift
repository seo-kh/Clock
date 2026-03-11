//
//  StartFlagDefaultsAdapter.swift
//  Stopwatch
//
//  Created by alphacircle on 3/11/26.
//

import Foundation

final class StartFlagDefaultsAdapter: LoadStartFlagPort, UpdateStartFlagPort {
    private let userDefaults: UserDefaults
    private static let defaultKey: String = "isRunnig"
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    convenience init() {
        self.init(userDefaults: UserDefaults())
    }
    
    func load(callback: @escaping (Bool) -> Void) {
        let flag = self.userDefaults.bool(forKey: Self.defaultKey)
        callback(flag)
    }
    
    func update(_ flag: Bool) {
        self.userDefaults.set(flag, forKey: Self.defaultKey)
    }
}
