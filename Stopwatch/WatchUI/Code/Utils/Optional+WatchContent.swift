//
//  Optional+WatchContent.swift
//  WatchUI
//
//  Created by alphacircle on 3/3/26.
//

import Foundation
import SwiftUI

/// 옵셔널 콘텐츠 익스텐션
///
/// WatchContentBuilder.buildIf(_:)을 적용하기 위한 필수 익스텐션
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
