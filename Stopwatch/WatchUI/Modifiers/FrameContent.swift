//
//  FrameContent.swift
//  WatchUI
//
//  Created by 테스트 on 2/19/26.
//

import SwiftUI
import Foundation

struct FrameContent<Content: WatchContent>: WatchContent {
    let widthRule: SizeRule
    let heightRule: SizeRule
    let content: () -> Content
    
    func render(_ context: inout GraphicsContext, rect: CGRect) {
        var newRect = rect
        newRect.size.width = widthRule.transform(from: rect.width)
        newRect.size.height = heightRule.transform(from: rect.height)
        
        content()
            .render(&context, rect: newRect)
    }
}

#Preview("number literal") {
    Watchface {
        Layer(alignment: .center) {
            ShapeMark(Rectangle())
                .frame(width: 100, height: 30)
            
            ShapeMark(Rectangle(), anchor: .topLeading, shading: .color(.orange))
                .offset(y: 100)
                .frame(height: 30) // 사이즈를 명시하지 않으면 부모의 사이즈를 사용
        }
    }
}

#Preview("fixed") {
    Watchface {
        Layer(alignment: .center) {
            ShapeMark(Rectangle())
                .frame(width: .fixed(100))
            
            ShapeMark(Rectangle(), anchor: .topLeading, shading: .color(.orange))
                .offset(y: -100)
                .frame(height: .fixed(49)) // number literal과 동일함
        }
    }
}

#Preview("equal") {
    Watchface {
        Layer(alignment: .center) {
            ShapeMark(Rectangle())
                .frame(width: .equal(100)) // 부모 너비의 반지름을 갖는 원을 100등분한 크기로 너비를 설정
            
            ShapeMark(Rectangle(), anchor: .topLeading, shading: .color(.orange))
                .offset(y: -100)
                .frame(width: .fixed(50), height: .equal(50)) // 부모 높이의 반지름을 갖는 원을 50등분한 크기로 높이를 설정
        }
    }
}
