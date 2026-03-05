//
//  Loop.swift
//  WatchUI
//
//  Created by alphacircle on 2/23/26.
//

import Foundation
import SwiftUI

/// 데이터 컬렉션 렌더링 컨테이너
///
/// ```swift
/// Watchface {
///     Layer {
///         Loop(data: [-30, 0, 30]) { offset in
///             ShapeMark(Rectangle(), anchor: .center)
///                 .frame(width: 40, height: 10)
///                 .offset(y: offset)
///         }
///     }
/// }
/// ```
/// 위 예제는 Loop의 사용법을 보여줍니다.
///
/// ![An image of loop watch content](loop.png)
public struct Loop<Data, Content>: WatchContent where Data: RandomAccessCollection, Content: WatchContent {
    let data: Data
    let content: (Data.Element) -> Content
    
    /// 기본 이니셜라이저
    /// - Parameters:
    ///   - data: 데이터 컬렉션
    ///   - content: 콘텐츠 클로저
    ///
    /// 역할: \
    /// `RandomAccessCollection`의 모든 요소를 순서대로 렌더링합니다. SwiftUI `ForEach`와 유사합니다.
    ///
    /// ```swift
    /// Loop(data: 0..<60) { i in
    ///     ShapeMark(Rectangle(), anchor: .top)
    ///         .coordinateRotation(angle: .degrees(6.0 * Double(i)))
    /// }
    /// ```
    public init(data: Data, @WatchContentBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        for element in data {
            content(element)
                .render(&context, rect: rect)
        }
    }
}

#Preview {
    Watchface {
        Layer {
            Loop(data: [-30, 0, 30]) { offset in
                ShapeMark(Rectangle(), anchor: .center)
                    .frame(width: 40, height: 10)
                    .offset(y: offset)
            }
        }
    }
}
