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

#Preview("if-else") {
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



#Preview("switch") {
    @Previewable @State var _foo: Int = 1
    Watchface {
        let foo = Layer {
            switch _foo {
            case 1:
                TextMark(anchor: .center) {
                    Text("bottom")
                        .font(.headline)
                }
            case 2:
                TextMark(anchor: .center) {
                    Text("center")
                        .font(.title)
                }
            default:
                TextMark(anchor: .center) {
                    Text("top")
                        .font(.largeTitle)
                }
            }
        }
        return foo
    }
}
