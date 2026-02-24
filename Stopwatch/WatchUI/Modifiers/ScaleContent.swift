//
//  ScaleContent.swift
//  WatchUI
//
//  Created by alphacircle on 2/24/26.
//

import Foundation
import SwiftUI

struct ScaleContent<Content: WatchContent>: WatchContent {
    let size: CGSize
    let content: () -> Content
    
    init(_ size: CGSize, content: @escaping () -> Content) {
        self.size = size
        self.content = content
    }
    
    func render(_ context: inout GraphicsContext, rect: CGRect) {
        var newRect = rect
        let newSize = rect.size.applying(.init(scaleX: size.width, y: size.height))
        newRect.size = newSize
        
        content()
            .render(&context, rect: newRect)
    }
}
