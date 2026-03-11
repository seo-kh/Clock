//
//  StopwatchControllerDelegate.swift
//  Stopwatch
//
//  Created by alphacircle on 3/11/26.
//

import Foundation

protocol StopwatchControllerDelegate {
    func didLoadLaps(_ target: Result<[Lap], Error>)
    func didAddLap(_ target: Lap)
    func didChangeStartFlag(_ target: Bool)
    func didChangeLifecycle(_ target: Bool)
}
