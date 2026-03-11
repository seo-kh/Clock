//
//  StopwatchBootControllerDelegate.swift
//  Stopwatch
//
//  Created by alphacircle on 3/11/26.
//

import Foundation

protocol StopwatchBootControllerDelegate {
    func lap(_ target: Result<[Lap], Error>)
    func mode(_ target: WatchMode)
    func lifecycle(_ target: Bool)
}