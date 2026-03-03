//
//  Optional+WatchContent.swift
//  WatchUI
//
//  Created by alphacircle on 3/3/26.
//

import Foundation
import SwiftUI

extension Optional: WatchContent where Wrapped: WatchContent {
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        if let self {
            self
                .render(&context, rect: rect)
        }
    }
}

#Preview("if-else") {
    @Previewable @State var _foo: Int = 1
    Watchface {
        let foo = Layer {
            
            if (_foo == 1) {
                TextMark(anchor: .center) {
                    Text("bottom")
                        .font(.title)
                }
            }
            
            if _foo == 2 {
                TextMark(anchor: .center) {
                    Text("center")
                        .font(.title)
                }
            }
        }
        return foo
    }
}
