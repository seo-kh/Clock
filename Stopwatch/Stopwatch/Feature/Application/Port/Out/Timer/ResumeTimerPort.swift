//
//  ResumeTimerPort.swift
//  Stopwatch
//
//  Created by alphacircle on 3/10/26.
//

import Foundation

protocol ResumeTimerPort {
    func resume(callback: @escaping (Date) -> Void)
}
