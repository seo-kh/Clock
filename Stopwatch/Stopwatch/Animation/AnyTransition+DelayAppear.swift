//
//  AnyTransition+DelayAppear.swift
//  Stopwatch
//
//  Created by alphacircle on 1/23/26.
//

import SwiftUI

extension AnyTransition {
    static func delayAppear(for seconds: TimeInterval) -> AnyTransition {
        .asymmetric(insertion: .opacity.animation(.linear(duration: 0.05).delay(seconds)),
                    removal: .identity)
    }
}

