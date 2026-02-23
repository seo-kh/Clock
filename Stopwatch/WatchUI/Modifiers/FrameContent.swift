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

#Preview("number literal") {
    Watchface {
        Layer(alignment: .center) {
            ShapeMark(Rectangle())
                .frame(width: 100, height: 30)
            
            ShapeMark(Rectangle(), shading: .color(.orange))
                .offset(y: 100)
                .frame(height: 30) // 사이즈를 명시하지 않으면 부모의 사이즈를 사용
        }
    }
}

#Preview("fixed") {
    Watchface {
        Layer(alignment: .center) {
            ShapeMark(Rectangle())
                .frame(width: 100)
            
            ShapeMark(Rectangle(), shading: .color(.orange))
                .offset(y: -100)
                .frame(height: 49) // number literal과 동일함
        }
    }
}

#Preview("equal") {
    Watchface {
        Layer(alignment: .center) {
            ShapeMark(Rectangle())
                .frame(width: 100) // 부모 너비의 반지름을 갖는 원을 100등분한 크기로 너비를 설정
            
            ShapeMark(Rectangle(), shading: .color(.orange))
                .offset(y: -100)
                .frame(width: 50, height: 50) // 부모 높이의 반지름을 갖는 원을 50등분한 크기로 높이를 설정
        }
    }
}
