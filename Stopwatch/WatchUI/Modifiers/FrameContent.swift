//
//  FrameContent.swift
//  WatchUI
//
//  Created by 테스트 on 2/19/26.
//

import SwiftUI
import Foundation

struct FrameContent<Content: WatchContent>: WatchContent {
    let width: CGFloat?
    let height: CGFloat?
    let content: () -> Content
    
    func render(_ context: inout GraphicsContext, rect: CGRect) {
        var newRect = rect
        newRect.size.width = width ?? rect.width
        newRect.size.height = height ?? rect.height
        
        content()
            .render(&context, rect: newRect)
    }
}

#Preview("frame") {
    Watchface {
        Layer(alignment: .center) {
            ShapeMark(Rectangle())
                .frame(width: 100, height: 30)
            
            ShapeMark(Rectangle(), anchor: .topLeading)
                .style(with: .color(.orange))
                .offset(y: 100)
                .frame(height: 30) // 사이즈를 명시하지 않으면 부모의 사이즈를 사용
        }
    }
}
