//
//  UpTransition.swift
//  Stopwatch
//
//  Created by alphacircle on 1/23/26.
//

import SwiftUI

struct UpTransition: Transition {
    let y: CGFloat
    
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .opacity(phase == .didDisappear ? 0 : 1)
            .offset(y: (phase == .willAppear) ? y : 0)
    }
}
    
extension Transition where Self == UpTransition {
    static func up(y: CGFloat) -> UpTransition {
        UpTransition(y: y)
    }
}
