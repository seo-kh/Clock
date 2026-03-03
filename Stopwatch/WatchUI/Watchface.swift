//
//  Watchface.swift
//  WatchUI
//
//  Created by alphacircle on 2/6/26.
//

import SwiftUI

/// WatchUI 프레임워크의 진입점.
///
/// ``WatchContent`` 트리를 SwiftUI `Canvas`로 렌더링합니다.
public struct Watchface<Content: WatchContent>: View {
    let content: () -> Content
    
    /// 콘텐츠 트리 구성
    ///
    /// - Parameter content: ``WatchContent`` 트리 클로저
    ///
    /// - `Canvas`를 생성하고, 캔버스 전체 영역을 루트 `rect`로 전달
    /// - `content()`를 호출하여 `WatchContent` 트리를 `render`
    public init(@WatchContentBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        Canvas { (context, size) in
            let rect = CGRect(origin: CGPoint.zero, size: size)
            
            content()
                .render(&context, rect: rect)
        }
    }
}

