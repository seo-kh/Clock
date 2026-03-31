//
//  StopwatchControllerDelegate.swift
//  Stopwatch
//
//  Created by alphacircle on 3/31/26.
//

import Foundation

protocol StopwatchControllerDelegate: AnyObject {
    func didGet(_ laps: [Lap])
    func didGet(_ flag: Bool)
    func didUpdate(_ date: Date)
    func didUpdate(_ activation: Bool)
    func didCompleteWithError(_ error: Error)
}
