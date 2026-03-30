//
//  LapRepository.swift
//  Stopwatch
//
//  Created by alphacircle on 3/30/26.
//

import Foundation

protocol LapRepository {
    func create(_ lap: Lap, completion: @escaping (Error?) -> Void)
    func read(completion: @escaping (Result<[Lap], Error>) -> Void)
    func delete(completion: @escaping (Error?) -> Void)
}
