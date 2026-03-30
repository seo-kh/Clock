//
//  FlagRepository.swift
//  Stopwatch
//
//  Created by alphacircle on 3/30/26.
//

import Foundation

protocol FlagRepository {
    func set(_ value: Bool, completion: @escaping (Error?) -> Void)
    func get(completion: @escaping (Result<Bool, Error>) -> Void)
}
