//
//  Layer.swift
//  WatchUI
//
//  Created by alphacircle on 2/12/26.
//

import SwiftUI

/// 특정 앵커 포인트를 원점으로 이동시켜 자식 콘텐츠를 배치합니다.
///
/// 시계 페이스에서 요소를 중앙, 상단 등 특정 위치에 고정할 때 사용합니다.
///
/// ```swift
/// Watchface {
///     Layer(anchor: .top) {
///         TextMark(anchor: .top) {
///             Text("Top")
///                 .foregroundStyle(.yellow)
///         }
///     }
///
///     Layer(anchor: .center) {
///         TextMark(anchor: .center) {
///             Text("Center")
///         }
///     }
///
///     Layer(anchor: .init(x: 0.75, y: 0.35)) {
///         TextMark(anchor: .center) {
///             Text("**x: 0.75, y: 0.35**")
///         }
///     }
/// }
/// ```
/// 위 코드는 기본적인 Layer 사용방법을 나타낸 예시입니다.
///
/// ![An image of Layer watch content](layer_1.png)
///
/// ---
///
/// ```swift
/// Watchface {
///     let data: [(anchor: UnitPoint, color: Color)] = [
///         (UnitPoint(x: 0.25, y: 0.25), Color.red),
///         (UnitPoint(x: 0.50, y: 0.25), Color.orange),
///         (UnitPoint(x: 0.75, y: 0.25), Color.yellow),
///
///         (UnitPoint(x: 0.25, y: 0.50), Color.green),
///         (UnitPoint(x: 0.50, y: 0.50), Color.cyan),
///         (UnitPoint(x: 0.75, y: 0.50), Color.blue),
///
///         (UnitPoint(x: 0.25, y: 0.75), Color.indigo),
///         (UnitPoint(x: 0.50, y: 0.75), Color.pink),
///         (UnitPoint(x: 0.75, y: 0.75), Color.purple),
///     ]
///
///     Loop(data: data) { element in
///         Layer(anchor: element.anchor) {
///             ShapeMark(Circle(), anchor: .center)
///                 .style(with: .color(element.color))
///                 .frame(width: 80, height: 80)
///         }
///     }
/// }
/// ```
/// 자식 콘텐츠를 특정 원점에 배치하도록 Unit Point를 설정할 수 있습니다.
///
/// ![An image of Layer watch content 2](layer_2.png)
/// 
public struct Layer<Content: WatchContent>: WatchContent {
    let anchor: UnitPoint
    let content: () -> Content
    
    /// Layer 그룹 생성
    /// - Parameters:
    ///   - anchor: 자식 콘텐츠의 원점이 될 위치
    ///   - content: 자식 콘텐츠
    public init(anchor: UnitPoint = .center, @WatchContentBuilder content: @escaping () -> Content) {
        self.anchor = anchor
        self.content = content
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        context.drawLayer { layerContext in
            let point = anchor.alignOriginPoint(to: rect)
            
            layerContext
                .translateBy(x: point.x, y: point.y)
            
            content()
                .render(&layerContext, rect: rect)
        }
    }
}

#Preview("demo") {
    Watchface {
        let data: [(anchor: UnitPoint, color: Color)] = [
            (UnitPoint(x: 0.25, y: 0.25), Color.red),
            (UnitPoint(x: 0.50, y: 0.25), Color.orange),
            (UnitPoint(x: 0.75, y: 0.25), Color.yellow),
            
            (UnitPoint(x: 0.25, y: 0.50), Color.green),
            (UnitPoint(x: 0.50, y: 0.50), Color.cyan),
            (UnitPoint(x: 0.75, y: 0.50), Color.blue),
            
            (UnitPoint(x: 0.25, y: 0.75), Color.indigo),
            (UnitPoint(x: 0.50, y: 0.75), Color.pink),
            (UnitPoint(x: 0.75, y: 0.75), Color.purple),
        ]
        
        Loop(data: data) { element in
            Layer(anchor: element.anchor) {
                ShapeMark(Circle(), anchor: .center)
                    .style(with: .color(element.color))
                    .frame(width: 80, height: 80)
            }
        }
    }
}

#Preview("layer mark render") {
    Watchface {
        Layer(anchor: .top) {
            TextMark(anchor: .top) {
                Text("Top")
                    .foregroundStyle(.yellow)
            }
        }
        
        Layer(anchor: .center) {
            TextMark(anchor: .center) {
                Text("Center")
            }
        }
        
        Layer(anchor: .init(x: 0.75, y: 0.35)) {
            TextMark(anchor: .center) {
                Text("**x: 0.75, y: 0.35**")
            }
        }
    }
}
