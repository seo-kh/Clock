//
//  Scale.swift
//  WatchUI
//
//  Created by alphacircle on 2/19/26.
//

import SwiftUI

/// 원형 눈금 레이아웃 컨테이너
///
/// ``Size``를 사용해 각 눈금의 크기를 정의하며, 그립니다.
///
/// ```swift
/// let width: SizeRule = .equal(total: 180)
/// let height: SizeRule = .fixed(10)
/// let y: SizeRule = .fixed(100)
///
/// Watchface {
///     Layer(anchor: .center) {
///         Scale(size: .init(y: y, width: width, height: height)) {
///             Loop(data: 0..<60) { _ in
///                 ShapeMark(Rectangle(), anchor: .top)
///                     .style(with: .color(.red))
///                     .coordinateRotation(angle: .degrees(360.0 / 60))
///             }
///         }
///     }
/// }
/// ```
///
/// 위 코드는 기본 이니셜라이저를 이용해 생성한 Scale 입니다. \
/// 직접 커스텀가능한 Scale을 만들 수 있습니다.
///
/// ![An image of Scale Watch Content](scale_cont_1.png)
///
/// ---
///
/// ```swift
///Watchface {
///    Layer(anchor: .center) {
///        Scale(0..<6, times: 4, period: 2) { tick in
///            ShapeMark(Circle(), anchor: .center)
///                .style(with: .color(Color(hue: tick.mark / 6.0, saturation: 1.0, brightness: 1.0)))
///                .aspectRatio(1.0)
///                .scale(tick.isBase ? 1.2 : 0.7)
///        }
///        .scale(0.9)
///    }
///}
/// ```
///
/// 위 코드는 간편 생성자를 이용해 Scale을 생성한 예제입니다. \
/// ``Tick``을 이용해 커스텀 스타일을 적용할 수 있습니다.
///
/// ![An image of Scale Watch Content 2](scale_cont_2.png)
public struct Scale<Content: WatchContent>: WatchContent {
    let size: Size
    let content: () -> Content
    
    /// 기본 이니셜라이저
    /// - Parameters:
    ///   - size: 눈금 영역의 크기 규칙
    ///   - content: 눈금 콘텐츠
    public init(size: Size, content: @escaping () -> Content) {
        self.size = size
        self.content = content
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        let length: CGFloat = min(rect.width, rect.height)
        let radius: CGFloat = length / 2.0
        let newRect: CGRect = size.makeCGRect(from: radius)

        content()
            .render(&context, rect: newRect)
    }
}

public extension Scale where Content == AnyWatchContent {
    
    /// 간편 이니셜라이저
    /// - Parameters:
    ///   - interval: 눈금의 기본(base) 범위
    ///   - times: base당 세분 눈금 수
    ///   - period: 눈금의 반복 주기
    ///   - scaleContent: 눈금 콘텐츠 클로저
    ///
    /// 눈금의 범위와 규칙을 이용하여 각 눈금의 크기와 자동으로 계산된 원형 각도를 이용해서 콘텐츠를 그립니다.
    ///
    /// > 계산 로직 \
    ///     `tickCount = interval.count × times` \
    ///     `total = tickCount × period` \
    ///     각 눈금 각도 = `360° / tickCount` \
    ///     `Size.width = .equal(total:)` 로 눈금 너비를 원주에 균등 분배
    ///
    /// ---
    ///
    /// 아래는 사용예시를 보여주는 코드입니다.
    /// ```swift
    /// Scale(0..<60) { tick in
    ///     ShapeMark(Rectangle(), anchor: .top)
    ///         .style(with: .color(tick.isBase ? .white : .gray))
    ///         .aspectRatio(tick.isBase ? 1.0/3.0 : 1.0/5.0)
    /// }
    /// ```
    init<R>(_ interval: Range<Int>, times: Int = 1, period: Int = 1, @WatchContentBuilder scaleContent: @escaping (Tick) -> R) where R: WatchContent {
        // tick의 사이즈 계산
        let _times = max(1, times)
        let _period = max(1, period)
        let _count = interval.count
        let tickCount = _count * _times
        let total = tickCount * _period
        let size: Size = Size(width: .equal(total: CGFloat(total)))
        
        // tick의 base, offset, delta, angle 계산 및 적용
        let offsetInterval = 0..<_times
        let delta = 1.0 / TimeInterval(_times)
        let angle = Angle(degrees: 360.0 / CGFloat(tickCount))
        
        self.init(size: size, content: {
            AnyWatchContent {
                Loop(data: interval) { base in
                    Loop(data: offsetInterval) { offset in
                        let tick = Tick(base: base, offset: offset, delta: delta)
                        
                        scaleContent(tick)
                            .coordinateRotation(angle: tick.isOrigin ? Angle.zero : angle)
                    }
                }
            }
        })
    }
}

#Preview("scale demo 1") {
    Watchface {
        Layer(anchor: .center) {
            Scale(0..<6, times: 4, period: 2) { tick in
                ShapeMark(Circle(), anchor: .center)
                    .style(with: .color(Color(hue: tick.mark / 6.0, saturation: 1.0, brightness: 1.0)))
                    .aspectRatio(1.0)
                    .scale(tick.isBase ? 1.2 : 0.7)
            }
            .scale(0.9)
        }
    }
}

 

#Preview("equal width") {
    let width: SizeRule = .equal(total: 180)
    let height: SizeRule = .identity
    let y: SizeRule = .identity
    
    Watchface {
        Layer(anchor: .center) {
            Scale(size: .init(y: y, width: width, height: height)) {
                Loop(data: 0..<60) { _ in
                    ShapeMark(Rectangle(), anchor: .top)
                        .style(with: .color(.red))
                        .coordinateRotation(angle: .degrees(360.0 / 60))
                }
            }
        }
    }
}

#Preview("fixed height") {
    let width: SizeRule = .equal(total: 180)
    let height: SizeRule = .fixed(10)
    let y: SizeRule = .identity
    
    Watchface {
        Layer(anchor: .center) {
            Scale(size: .init(y: y, width: width, height: height)) {
                Loop(data: 0..<60) { _ in
                    ShapeMark(Rectangle(), anchor: .top)
                        .style(with: .color(.red))
                        .coordinateRotation(angle: .degrees(360.0 / 60))
                }
            }
        }
    }
}

#Preview("fixed position") {
    let width: SizeRule = .equal(total: 180)
    let height: SizeRule = .fixed(10)
    let y: SizeRule = .fixed(100)
    
    Watchface {
        Layer(anchor: .center) {
            Scale(size: .init(y: y, width: width, height: height)) {
                Loop(data: 0..<60) { _ in
                    ShapeMark(Rectangle(), anchor: .top)
                        .style(with: .color(.red))
                        .coordinateRotation(angle: .degrees(360.0 / 60))
                }
            }
        }
    }
}
