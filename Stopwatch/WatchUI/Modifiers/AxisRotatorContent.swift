//
//  AxisRotatorContent.swift
//  WatchUI
//
//  Created by alphacircle on 2/19/26.
//

import Foundation
import SwiftUI

struct AxisRotatorContent<Content: WatchContent>: WatchContent {
    let angle: Angle
    let content: () -> Content
    
    func render(_ context: inout GraphicsContext, rect: CGRect) {
        let transform = CGAffineTransform(rotationAngle: angle.radians)
        let newRect = rect.applying(transform)
        content()
            .render(&context, rect: newRect)
    }
}
