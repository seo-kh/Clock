//
//  LoadLapPort.swift
//  Stopwatch
//
//  Created by alphacircle on 3/11/26.
//

import Foundation

protocol LoadLapPort {
    func load(callback: @escaping (Result<[Lap], Error>) -> Void)
}
