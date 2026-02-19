//
//  OffsetContent.swift
//  WatchUI
//
//  Created by alphacircle on 2/19/26.
//

import Foundation
import SwiftUI

struct OffsetContent<Content: WatchContent>: WatchContent {
    let offset: CGPoint
    let content: () -> Content
    
    func render(_ context: inout GraphicsContext, rect: CGRect) {
        let transform = CGAffineTransform(translationX: offset.x, y: offset.y)
        let newRect = rect.applying(transform)
        content()
            .render(&context, rect: newRect)
    }
}

