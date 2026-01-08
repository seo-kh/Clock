//
//  StopwatchScreen.swift
//  Stopwatch
//
//  Created by alphacircle on 1/5/26.
//

import SwiftUI
import Foundation

struct StopwatchScreen: View {
    @State
    private var stopwatch = Stopwatch()
    
    @State
    private var isActive: Bool = true
    
    var body: some View {
        _StopwatchScreen(laps: stopwatch.laps, components: stopwatch.components, isActive: isActive)
            .onFocus({ isActive in
                self.isActive = isActive
            })
    }
}

extension StopwatchScreen._StopwatchScreen {
    func onFocus(_ action: @escaping (Bool) -> Void) -> some View {
        self
            .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
                action(true)
            }
            .onReceive(NotificationCenter.default.publisher(for: NSApplication.didResignActiveNotification)) { _ in
                action(false)
            }
    }
}

extension StopwatchScreen {
    /// Stateless Stopwatch UI Screen
    struct _StopwatchScreen: View {
        let laps: [Lap]
        let components: [ActionComponent]
        let isActive: Bool
        
        private var currentLap: Lap {
            switch laps.first {
            case .none: Lap.empty
            case .some(let _current): _current
            }
        }
        
        var body: some View {
            VStack(alignment: .center, spacing: 0.0) {
                TimeLabel(lap: currentLap)
                    .padding(.vertical, 20.0)
                
                LapList(laps: laps)
                
                ActionGroup(components: components, isActive: isActive)
                    .padding(.vertical, 40.0)
            }
            .frame(maxWidth: CGFloat.infinity, maxHeight: CGFloat.infinity)
            .background(CKColor.background)
        }
    }
}

#Preview("Start") {
    StopwatchScreen._StopwatchScreen(laps: [], components: [], isActive: true)
        .frame(
            minWidth: 600,
            idealWidth: 600,
            maxWidth: CGFloat.infinity,
            minHeight: 610,
            idealHeight: 610,
            maxHeight: CGFloat.infinity
        )
}

#Preview("Empty") {
    StopwatchScreen._StopwatchScreen(laps: [], components: [], isActive: true)
        .frame(
            minWidth: 600,
            idealWidth: 600,
            maxWidth: CGFloat.infinity,
            minHeight: 610,
            idealHeight: 610,
            maxHeight: CGFloat.infinity
        )
}

#Preview("Stopwatch") {
    StopwatchScreen._StopwatchScreen(laps: [], components: [], isActive: true)
        .frame(
            minWidth: 600,
            idealWidth: 600,
            maxWidth: CGFloat.infinity,
            minHeight: 610,
            idealHeight: 610,
            maxHeight: CGFloat.infinity
        )
}


