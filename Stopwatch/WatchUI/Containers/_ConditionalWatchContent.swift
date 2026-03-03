//
//  _ConditionalWatchContent.swift
//  WatchUI
//
//  Created by alphacircle on 3/3/26.
//

import Foundation
import SwiftUI

public struct _ConditionalWatchContent<TrueContent, FalseContent>: WatchContent where TrueContent: WatchContent, FalseContent: WatchContent {
    let trueContent: (() -> TrueContent)?
    let falseContent: (() -> FalseContent)?

    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        if let trueContent {
            trueContent()
                .render(&context, rect: rect)
        } else if let falseContent {
            falseContent()
                .render(&context, rect: rect)
        }
    }
}

#Preview("if-else condition demo 1") {
    @Previewable @State var isOn: Bool = false
    
    VStack {
        Toggle("toggle", isOn: $isOn)
        
        Watchface {
            let foo = Layer(anchor: .center) {
                ShapeMark(Circle(), anchor: .center)
                    .style(with: .color(isOn ? .blue : .pink))
                
                if isOn {
                    TextMark(text: "is On")
                } else {
                    TextMark(text: "is Off")
                }
            }
            
            return foo
        }
    }
}
