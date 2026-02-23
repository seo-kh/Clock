//
//  AspectRatioContent.swift
//  WatchUI
//
//  Created by alphacircle on 2/23/26.
//

import Foundation
import SwiftUI

struct AspectRatioContent<Content: WatchContent>: WatchContent {
    let aspectRatio: CGFloat
    let content: () -> Content
    
    func render(_ context: inout GraphicsContext, rect: CGRect) {
        var _rect = rect
        _rect.size.height = _rect.width / aspectRatio
        
        content()
            .render(&context, rect: _rect)
    }
}

#Preview {
    Watchface {
        Layer(alignment: .center) {
            ShapeMark(Rectangle())
                .aspectRatio(1.0 / 2.0) // width : height = 1 : 2
                .frame(width: 50, height: 500) // aspect ratio가 설정되면 height는 무시됨.
        }
    }
}

