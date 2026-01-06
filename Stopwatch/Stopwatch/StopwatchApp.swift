//
//  StopwatchApp.swift
//  Stopwatch
//
//  Created by alphacircle on 1/5/26.
//

import SwiftUI

@main
struct StopwatchApp: App {
    var body: some Scene {
        WindowGroup {
            StopwatchScreen()
                .frame(
                    minWidth: 600,
                    idealWidth: 600,
                    maxWidth: CGFloat.infinity,
                    minHeight: 610,
                    idealHeight: 610,
                    maxHeight: CGFloat.infinity
                )
        }
        .windowResizability(.contentSize)
    }
}
