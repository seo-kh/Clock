//
//  ActionComponent.swift
//  Stopwatch
//
//  Created by alphacircle on 1/6/26.
//

import Foundation

struct ActionComponent: Identifiable {
    let title: String
    let action: (() -> Void)?
    let style: ClockButtonStyle
    
    var id: String { self.title }
}

extension Array where Element == ActionComponent {
    static var idle: Self {
        [
            ActionComponent(title: "Lap", action: nil, style: .ckDisable),
            ActionComponent(title: "Start", action: {}, style: .ckGreen),
        ]
    }
    
    static var start: Self {
        [
            ActionComponent(title: "Lap", action: {}, style: .ckGray),
            ActionComponent(title: "Stop", action: {}, style: .ckRed),
        ]
    }
    
    static var stop: Self {
        [
            ActionComponent(title: "Reset", action: {}, style: .ckGray),
            ActionComponent(title: "Start", action: {}, style: .ckGreen),
        ]
    }
}
