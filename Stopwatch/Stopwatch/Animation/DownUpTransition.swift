//
//  DownUpTransition.swift
//  Stopwatch
//
//  Created by alphacircle on 1/23/26.
//

import SwiftUI

struct DownUpTransition: Transition {
    let y: CGFloat
    
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .offset(y: (phase == .identity) ? 0 : y)
    }
}

extension Transition where Self == DownUpTransition {
    static func downUp(y: CGFloat) -> DownUpTransition {
        DownUpTransition(y: y)
    }
}
