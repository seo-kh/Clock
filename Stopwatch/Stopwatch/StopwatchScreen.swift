//
//  StopwatchScreen.swift
//  Stopwatch
//
//  Created by james seo on 1/5/26.
//

import SwiftUI
import Foundation

struct StopwatchScreen: View {
    @State
    private var stopwatch = _Stopwatch(configuration: .memory(timeInterval: 0.03))
    
    var body: some View {
        _StopwatchScreen(laps: stopwatch.laps,
                         components: stopwatch.components,
                         watchMode: stopwatch.watchMode)
    }
}

/// macOS Specific model
struct WatchMode {
    var isActive: Bool
    var change: () -> Void
    
    init(isActive: Bool = false, change: @escaping () -> Void = {}) {
        self.isActive = isActive
        self.change = change
    }
}

extension StopwatchScreen {
    /// Stateless Stopwatch UI Screen
    struct _StopwatchScreen: View {
        let laps: [Lap]
        let components: ActionComponents
        let watchMode: WatchMode
        
        private var currentLap: Lap {
            switch laps.first {
            case .none: Lap.empty
            case .some(let _current): _current
            }
        }
        
        var body: some View {
            VStack(alignment: .center, spacing: 0.0) {
                Group {
                    if watchMode.isActive {
                        Spacer()
                        
                        StopwatchFace(lap: laps.first ?? .empty, engine: .dsl)
                            .aspectRatio(1.0 / 1.0, contentMode: .fit)
                            .frame(width: 370)
                            .onTapGesture {
                                watchMode.change()
                            }
                            .transition(.delayAppear(for: 0.20))
                        
                        Spacer()
                    } else {
                        TimeLabel(lap: currentLap)
                            .padding(.vertical, 20.0)
                            .onTapGesture {
                                watchMode.change()
                            }
                            .transition(.downUp(y: 200))

                        LapList(laps: laps)
                            .transition(.up(y: 280))
                    }
                }
                .animation(.easeOut(duration: 0.20), value: watchMode.isActive)

                ActionGroup(components: components)
                    .padding(.vertical, 40.0)
            }
            .frame(maxWidth: CGFloat.infinity, maxHeight: CGFloat.infinity)
            .background(CKColor.background)
        }
    }
}

#Preview("Start") {
    StopwatchScreen._StopwatchScreen(laps: .dummy, components: .idle, watchMode: .init())
        .frame(
            minWidth: 600,
            idealWidth: 600,
            maxWidth: CGFloat.infinity,
            minHeight: 610,
            idealHeight: 610,
            maxHeight: 610
        )
}

#Preview("Empty") {
    StopwatchScreen._StopwatchScreen(laps: .dummy, components: .idle, watchMode: .init())
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
    StopwatchScreen._StopwatchScreen(laps: .dummy, components: .idle, watchMode: .init())
        .frame(
            minWidth: 600,
            idealWidth: 600,
            maxWidth: CGFloat.infinity,
            minHeight: 610,
            idealHeight: 610,
            maxHeight: CGFloat.infinity
        )
}

#Preview("Start - watch") {
    StopwatchScreen._StopwatchScreen(laps: .dummy, components: .idle, watchMode: .init(isActive: true))
        .frame(
            minWidth: 600,
            idealWidth: 600,
            maxWidth: CGFloat.infinity,
            minHeight: 610,
            idealHeight: 610,
            maxHeight: CGFloat.infinity
        )
}

#Preview("Empty - watch") {
    StopwatchScreen._StopwatchScreen(laps: .dummy, components: .idle, watchMode: .init(isActive: true))
        .frame(
            minWidth: 600,
            idealWidth: 600,
            maxWidth: CGFloat.infinity,
            minHeight: 610,
            idealHeight: 610,
            maxHeight: CGFloat.infinity
        )
}


#Preview("Stopwatch - watch") {
    StopwatchScreen._StopwatchScreen(laps: .dummy, components: .idle, watchMode: .init(isActive: true))
        .frame(
            minWidth: 600,
            idealWidth: 600,
            maxWidth: CGFloat.infinity,
            minHeight: 610,
            idealHeight: 610,
            maxHeight: CGFloat.infinity
        )
}

