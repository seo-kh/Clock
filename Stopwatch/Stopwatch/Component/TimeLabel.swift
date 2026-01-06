//
//  TimeLabel.swift
//  Stopwatch
//
//  Created by alphacircle on 1/6/26.
//

import SwiftUI

extension StopwatchScreen._StopwatchScreen {
    struct TimeLabel: View {
        let elapsedTime: String
        
        var body: some View {
            Text(elapsedTime)
            .foregroundStyle(CKColor.label)
            .font(.system(size: 110, weight: .thin, design: .default))
            .tracking(3.0)
        }
    }
}

#Preview {
    StopwatchScreen._StopwatchScreen.TimeLabel(elapsedTime: "00.03:34")
        .background(CKColor.background)
}
