//
//  ActionGroup.swift
//  Stopwatch
//
//  Created by james seo on 1/6/26.
//

import SwiftUI

extension StopwatchScreen._StopwatchScreen {
    struct ActionGroup: View {
        let components: ActionComponents
        
        var body: some View {
            HStack(alignment: .center, spacing: 16.0) {
                Button(components.leading.title) {
                    components.leading.action?()
                }
                .buttonStyle(components.leading.style)
                .disabled(components.leading.isDisable)
                
                Button(components.trailing.title) {
                    components.trailing.action?()
                }
                .buttonStyle(components.trailing.style)
                .disabled(components.trailing.isDisable)
            } // button group
        }
    }
}

#Preview("InActive Buttons - Idle") {
    StopwatchScreen._StopwatchScreen.ActionGroup(components: .idle)
}

#Preview("InActive Buttons - Start") {
    StopwatchScreen._StopwatchScreen.ActionGroup(components: .start)
}

#Preview("InActive Buttons - Stop") {
    StopwatchScreen._StopwatchScreen.ActionGroup(components: .stop)
}

#Preview("Active Buttons - Idle") {
    StopwatchScreen._StopwatchScreen.ActionGroup(components: .idle)
}

#Preview("Active Buttons - Start") {
    StopwatchScreen._StopwatchScreen.ActionGroup(components: .start)
}

#Preview("Active Buttons - Stop") {
    StopwatchScreen._StopwatchScreen.ActionGroup(components: .stop)
}
