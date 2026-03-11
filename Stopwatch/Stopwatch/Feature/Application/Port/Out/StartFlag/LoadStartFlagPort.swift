//
//  LoadStartFlagPort.swift
//  Stopwatch
//
//  Created by alphacircle on 3/11/26.
//

import Foundation

protocol LoadStartFlagPort {
    func load(callback: @escaping (Bool) -> Void)
}
