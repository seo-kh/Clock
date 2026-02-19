//
//  CoordinateRotatorContent.swift
//  WatchUI
//
//  Created by alphacircle on 2/19/26.
//

import Foundation
import SwiftUI

struct CoordinateRotatorContent<Content: WatchContent>: WatchContent {
    let angle: Angle
    let inplace: Bool
    let content: () -> Content
    
    init(angle: Angle, inplace: Bool, content: @escaping () -> Content) {
        self.angle = angle
        self.content = content
        self.inplace = inplace
    }
    
    func render(_ context: inout GraphicsContext, rect: CGRect) {
        context.rotate(by: angle)
        
        content().render(&context, rect: rect)
        
        if inplace {
            context.rotate(by: -angle)
        }
    }
}
