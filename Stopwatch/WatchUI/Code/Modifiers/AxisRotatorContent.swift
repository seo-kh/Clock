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
        let newPoint = rect.origin.applying(transform)
        var newRect = rect
        newRect.origin = newPoint

        content()
            .render(&context, rect: newRect)
    }
}

#Preview {
    Watchface {
        Layer(anchor: .center) {
            TextMark(text: "º", anchor: .center)
            
            Loop(data: 0..<6) { i in
                TextMark(text: "\(i)", anchor: .center)
                    .axisRotation(angle: .degrees(30.0 * Double(i))) // rect.point가 zero면 axis rotation이 동작하지 않음.
                    .offset(x: -75)
            }
        }
    }
}
