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
