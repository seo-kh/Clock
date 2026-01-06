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
    private var laps: [Lap] = []
    
    var body: some View {
        _StopwatchScreen(laps: laps, buttons: [ActionButton].dummy)
    }
}

extension StopwatchScreen {
    /// Stateless Stopwatch UI Screen
    struct _StopwatchScreen: View {
        let laps: [Lap]
        let buttons: [ActionButton]
        
        private var elapsedTime: String {
            switch laps.first {
            case .none: "00:00.00"
            case .some(let _current): _current.total
            }
        }
        
        var body: some View {
            VStack(alignment: .center, spacing: 0.0) {
                TimeLabel(elapsedTime: elapsedTime)
                    .padding(.vertical, 20.0)
                
                LapList(laps: laps)
                
                ActionGroup(buttons: buttons)
                    .padding(.vertical, 40.0)
            }
            .frame(maxWidth: CGFloat.infinity, maxHeight: CGFloat.infinity)
            .background(CKColor.background)
        }
    }
}

#Preview("Start") {
    StopwatchScreen._StopwatchScreen(laps: [Lap.dummy], buttons: [ActionButton].dummy)
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
    StopwatchScreen._StopwatchScreen(laps: [], buttons: [ActionButton].dummy)
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
    StopwatchScreen._StopwatchScreen(laps: [Lap.dummy] + [Lap].dummy, buttons: [ActionButton].dummy)
        .frame(
            minWidth: 600,
            idealWidth: 600,
            maxWidth: CGFloat.infinity,
            minHeight: 610,
            idealHeight: 610,
            maxHeight: CGFloat.infinity
        )
}


