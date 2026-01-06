//
//  ActionButton.swift
//  Stopwatch
//
//  Created by alphacircle on 1/6/26.
//

import Foundation

struct ActionButton: Identifiable {
    let title: String
    let action: (() -> Void)?
    let style: ClockButtonStyle
    
    var id: String { self.title }
}

extension Array where Element == ActionButton {
    static var dummy: Self {
        [
            ActionButton(title: "Reset", action: nil, style: .ckDisable),
            ActionButton(title: "Start", action: {}, style: .ckGreen),
        ]
    }
}
