//
//  AppActivationSource.swift
//  Stopwatch
//
//  Created by alphacircle on 3/30/26.
//

import Foundation

protocol AppActivationSource {
    func start(onUpdate: @escaping (Result<Bool, Error>) -> Void)
    func stop(completion: @escaping (Error?) -> Void)
}
