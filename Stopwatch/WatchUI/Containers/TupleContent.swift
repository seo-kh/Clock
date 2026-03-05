//
//  TupleContent.swift
//  WatchUI
//
//  Created by 테스트 on 2/28/26.
//

import Foundation
import SwiftUI

/// 다중 콘텐츠 컨테이너
///
/// 여러 ``WatchContent``를 하나로 묶습니다. \
/// ``WatchContentBuilder``의 `buildBlock`이 다중 요소를 받을 때 생성됩니다.
///
/// ```swift
/// Watchface {
///     // foo type:  Layer<TupleContent<(TextMark, TextMark, TextMark)>>
///     let foo = Layer {
///         TextMark(anchor: .center) {
///             Text("top")
///                 .font(.largeTitle)
///         }
///
///         TextMark(anchor: .center) {
///             Text("center")
///                 .font(.title)
///         }
///
///         TextMark(anchor: .center) {
///             Text("bottom")
///                 .font(.headline)
///         }
///     }
///     return foo
/// }
/// ```
public struct TupleContent<T>: WatchContent {
    /// 컨테이터 값
    public var value: T
    private var _render: ((inout GraphicsContext, CGRect) -> Void)?
    
    /// 기본 이니셜라이저
    /// - Parameter value: 컨테이너 값
    public init(_ value: T) {
        self.value = value
        self._render = nil
    }
    
    init<each Content: WatchContent>(contents: (repeat each Content)) where T == (repeat each Content) {
        self.value = contents
        self._render = self.__render(_:rect:)
    }
    
    private func __render<each Content: WatchContent>(_ context: inout GraphicsContext, rect: CGRect) where T == (repeat each Content) {
        for content in repeat each value {
            content
                .render(&context, rect: rect)
        }
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        _render?(&context, rect)
    }
}

#Preview("default") {
    Watchface {
        let foo = Layer {                   // foo의 타입은  Layer<TupleContent<(TextMark, TextMark, TextMark)>> 이다.
            TextMark(anchor: .center) {
                Text("top")
                    .font(.largeTitle)
            }
            
            TextMark(anchor: .center) {
                Text("center")
                    .font(.title)
            }
            
            TextMark(anchor: .center) {
                Text("bottom")
                    .font(.headline)
            }
        }
        return foo
    }
}

