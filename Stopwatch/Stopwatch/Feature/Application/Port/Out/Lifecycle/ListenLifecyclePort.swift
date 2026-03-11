//
//  ListenLifecyclePort.swift
//  Stopwatch
//
//  Created by alphacircle on 3/11/26.
//

import Foundation

protocol ListenLifecyclePort {
    func listen(callback: @escaping (Bool) -> Void)
}
