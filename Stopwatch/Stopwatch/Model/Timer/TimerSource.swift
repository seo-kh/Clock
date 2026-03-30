//
//  TimerSource.swift
//  Stopwatch
//
//  Created by alphacircle on 3/30/26.
//

import Foundation

protocol TimerSource {
    func start(onUpdate: @escaping (Result<Date, Error>) -> Void)
    func stop(onCompletion: @escaping (Error?) -> Void)
}
