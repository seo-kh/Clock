//
//  Index.swift
//  WatchUI
//
//  Created by 테스트 on 2/19/26.
//

import SwiftUI

/// 시계 숫자판(12, 3, 6, 9 등)을 구성할 때 사용합니다.
///
/// 시계 숫자판을 원형으로 구성하는 컨테이너 콘텐츠입니다.
///
/// ```swift
/// Watchface {
///     Layer(anchor: .center) {
///         Index(["30", "5", "10", "15", "20", "25"]) { sec in
///             TextMark(anchor: .center) {
///                 Text(sec)
///                     .font(.system(size: 14))
///                     .foregroundStyle(.white)
///             }
///         }
///         .frame(width: 160, height: 160)
///     }
/// }
/// ```
/// 위 예시는 기본적인 Index를 생성을 보여줍니다.
///
/// ![An image of index watch content.](index.png)
///
public struct Index<Content>: WatchContent where Content: WatchContent {
    let size: Size
    let content: () -> Content
    
    /// 기본 이니셜라이저
    /// - Parameters:
    ///   - size: 구성요소의 크기 규칙
    ///   - content: 구성요소 콘텐츠
    public init(size: Size, content: @escaping () -> Content) {
        self.size = size
        self.content = content
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        let length: CGFloat = min(rect.width, rect.height)
        let radius: CGFloat = length / 2.0
        let newRect: CGRect = size.makeCGRect(length: radius)
        
        content()
            .render(&context, rect: newRect)
    }
}

public extension Index {
    /// `RandomAccessCollection`의 각 요소를 원형으로 균등 배치합니다.
    ///
    /// - Parameters:
    ///   - data: 데이터 컬렉션
    ///   - indexContent: 데이터 요소 인덱스 콘텐츠
    ///
    /// **동작**
    /// - 컬렉션 원소 수에 따라 원주를 균등 분배 (2π / count)
    /// - 각 요소에 `axisRotation`을 적용하여 원형 배치
    /// - 내부적으로 `Loop` + `AnyWatchContent` 조합으로 구현
    ///
    /// ```swift
    /// Index(["12", "3", "6", "9"]) { label in
    ///     TextMark(anchor: .center) {
    ///         Text(label).foregroundStyle(.white)
    ///     }
    /// }
    /// .frame(width: 160, height: 160)
    /// ```
    init<D, R>(_ data: D, @WatchContentBuilder indexContent: @escaping (D.Element) -> R) where D: RandomAccessCollection, D.Element: Equatable, R: WatchContent, Content == AnyWatchContent {
        let total: CGFloat = CGFloat(data.count)
        let radians: CGFloat = 2.0 * CGFloat.pi / total
        let size: Size = .init(width: .equal(total: total))
        let indicies = 0..<data.count
        
        self.init(size: size, content: {
            AnyWatchContent {
                Loop(data: indicies) { index in
                    let angle: Angle = Angle.radians(radians * CGFloat(index))
                    let offset = data.index(data.startIndex, offsetBy: index)
                    return indexContent(data[offset]).axisRotation(angle: angle)
                }
            }
        })
    }
}

#Preview("index face") {
    Watchface {
        Layer(anchor: .center) {
            Index(["30", "5", "10", "15", "20", "25"]) { sec in
                TextMark(anchor: .center) {
                    Text(sec)
                        .font(.system(size: 14))
                        .foregroundStyle(.white)
                }
            }
            .frame(width: 160, height: 160)
        }
    }
}

#Preview("loop") {
    Watchface {
        Layer(anchor: .center) {
            Index(0..<10, indexContent: { i in
                TextMark(anchor: .center) {
                    Text("\(i)")
                        .font(.largeTitle)
                }
            })
            .frame(width: 160, height: 160)
        }
    }
}

