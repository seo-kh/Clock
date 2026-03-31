//
//  DisplayMode.swift
//  Stopwatch
//
//  Created by alphacircle on 3/31/26.
//

import Foundation

enum DisplayMode {
    case list
    case watch
    
    mutating func toggle() {
        switch self {
        case .list:
            self = .watch
        case .watch:
            self = .list
        }
    }
}
