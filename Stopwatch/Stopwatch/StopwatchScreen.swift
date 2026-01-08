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
    var stopwatch = Stopwatch()
    
    var body: some View {
        _StopwatchScreen(laps: stopwatch.laps,
                         buttons: stopwatch.buttons)
    }
}

extension StopwatchScreen {
    /// Stateless Stopwatch UI Screen
    struct _StopwatchScreen: View {
        let laps: [Lap]
        let buttons: [ActionButton]
        
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
                
                ActionGroup(buttons: buttons)
                    .padding(.vertical, 40.0)
            }
            .frame(maxWidth: CGFloat.infinity, maxHeight: CGFloat.infinity)
            .background(CKColor.background)
        }
    }
}

#Preview("Start") {
    StopwatchScreen._StopwatchScreen(laps: [], buttons: [])
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
    StopwatchScreen._StopwatchScreen(laps: [], buttons: [])
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
    StopwatchScreen._StopwatchScreen(laps: [], buttons: [])
        .frame(
            minWidth: 600,
            idealWidth: 600,
            maxWidth: CGFloat.infinity,
            minHeight: 610,
            idealHeight: 610,
            maxHeight: CGFloat.infinity
        )
}


