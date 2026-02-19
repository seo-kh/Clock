//
//  WatchContent.swift
//  WatchUI
//
//  Created by alphacircle on 2/6/26.
//

import SwiftUI

public protocol WatchContent {
    func render(_ context: inout GraphicsContext, rect: CGRect)
}

public extension WatchContent {
    func coordinateRotation(angle: Angle, inplace: Bool = false) -> some WatchContent {
        CoordinateRotatorContent(angle: angle, inplace: inplace, content: { self })
    }
    
    func axisRotation(angle: Angle) -> some WatchContent {
        AxisRotatorContent(angle: angle, content: { self })
    }

    func offset(_ offset: CGPoint) -> some WatchContent {
        OffsetContent(offset: offset, content: { self })
    }
    
    func offset(x: CGFloat = 0.0, y: CGFloat = 0.0) -> some WatchContent {
        OffsetContent(offset: CGPoint(x: x, y: y), content: { self })
    }
}
