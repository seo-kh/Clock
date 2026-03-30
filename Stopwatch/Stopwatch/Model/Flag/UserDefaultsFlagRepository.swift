//
//  UserDefaultsFlagRepository.swift
//  Stopwatch
//
//  Created by alphacircle on 3/30/26.
//

import Foundation

final class UserDefaultsFlagRepository: FlagRepository {
    private let userDefaults: UserDefaults
    private let key: String = "isRunning"
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    convenience init() {
        self.init(userDefaults: UserDefaults())
    }
    
    func get(completion: @escaping (Result<Bool, any Error>) -> Void) {
        let flag = self.userDefaults.bool(forKey: key)
        completion(Result.success(flag))
    }
    
    func set(_ value: Bool, completion: @escaping ((any Error)?) -> Void) {
        self.userDefaults.set(value, forKey: key)
        completion(nil)
    }
}
