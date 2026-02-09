//
//  TimeLabel.swift
//  Stopwatch
//
//  Created by alphacircle on 1/6/26.
//

import SwiftUI

extension StopwatchScreen._StopwatchScreen {
    struct TimeLabel: View {
        let progress: Date
        let startAt: Date
        
        init(progress: Date, startAt: Date) {
            self.progress = progress
            self.startAt = startAt
        }
        
        init(lap: Lap) {
            self.progress = lap.progress
            self.startAt = lap.total
        }
        
        var body: some View {
            Text(self.progress, format: .stopwatch(startingAt: self.startAt))
            .foregroundStyle(CKColor.label)
            .font(.system(size: 110, weight: .thin, design: .default))
            .tracking(3.0)
        }
        
        func d() {
            let d = Text("h")
        }
    }
}

#Preview {
    StopwatchScreen._StopwatchScreen.TimeLabel(progress: .now.addingTimeInterval(30), startAt: .now)
        .background(CKColor.background)
}
