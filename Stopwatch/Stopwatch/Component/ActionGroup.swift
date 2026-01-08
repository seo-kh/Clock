//
//  ActionGroup.swift
//  Stopwatch
//
//  Created by alphacircle on 1/6/26.
//

import SwiftUI

extension StopwatchScreen._StopwatchScreen {
    struct ActionGroup: View {
        let components: [ActionComponent]
        let isActive: Bool
        
        var body: some View {
            HStack(alignment: .center, spacing: 16.0) {
                ForEach(components) { component in
                    self.actionButton(component, isActive: isActive)
                }
            } // button group
        }
        
        func actionButton(_ component: ActionComponent, isActive: Bool) -> some View {
            let style: ClockButtonStyle = switch (component.action, isActive) {
            case (nil, _): ClockButtonStyle.ckDisable
            case (_, true): component.style
            case (_, false):ClockButtonStyle.ckGray
            }
            
            return Button(component.title) {
                component.action?()
            }
            .buttonStyle(style)
            .disabled(component.action == nil)
        }
    }
}

#Preview("InActive Buttons - Idle") {
    StopwatchScreen._StopwatchScreen.ActionGroup(components: [ActionComponent].idle, isActive: false)
}

#Preview("InActive Buttons - Start") {
    StopwatchScreen._StopwatchScreen.ActionGroup(components: [ActionComponent].start, isActive: false)
}

#Preview("InActive Buttons - Stop") {
    StopwatchScreen._StopwatchScreen.ActionGroup(components: [ActionComponent].stop, isActive: false)
}

#Preview("Active Buttons - Idle") {
    StopwatchScreen._StopwatchScreen.ActionGroup(components: [ActionComponent].idle, isActive: true)
}

#Preview("Active Buttons - Start") {
    StopwatchScreen._StopwatchScreen.ActionGroup(components: [ActionComponent].start, isActive: true)
}

#Preview("Active Buttons - Stop") {
    StopwatchScreen._StopwatchScreen.ActionGroup(components: [ActionComponent].stop, isActive: true)
}
