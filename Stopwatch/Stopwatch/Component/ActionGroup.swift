//
//  ActionGroup.swift
//  Stopwatch
//
//  Created by alphacircle on 1/6/26.
//

import SwiftUI

extension StopwatchScreen._StopwatchScreen {
    struct ActionGroup: View {
        let buttons: [ActionButton]
        
        init(buttons: [ActionButton]) {
            self.buttons = buttons
        }
        
        var body: some View {
            HStack(alignment: .center, spacing: 16.0) {
                ForEach(buttons) { button in
                    Button(button.title) {
                        button.action?()
                    }
                    .buttonStyle(button.style)
                    .disabled(button.action == nil)
                }
            } // button group
        }
    }
}

#Preview {
    StopwatchScreen._StopwatchScreen.ActionGroup(buttons: [ActionButton].dummy)
}
