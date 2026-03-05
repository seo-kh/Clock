//
//  WatchContent.swift
//  WatchUI
//
//  Created by alphacircle on 2/6/26.
//

import SwiftUI

/// 프레임워크의 핵심 프로토콜
///
/// 모든 렌더링 가능한 요소가 구현해야 합니다.
public protocol WatchContent {
    /// 주어진 `GraphicsContext`와 `CGRect` 내에 콘텐츠를 그림
    /// - Parameters:
    ///   - context: 드로잉 컨텍스트
    ///   - rect: 콘텐츠 사이즈
    func render(_ context: inout GraphicsContext, rect: CGRect)
}

public extension WatchContent {
    /// 그래픽 좌표계 회전
    /// - Parameter angle: 회전 각도
    /// - Returns: 회전된 좌표계에서 그려지는 콘텐츠
    ///
    /// ```swift
    /// Watchface {
    ///     Layer(anchor: .center) {
    ///         ShapeMark(Rectangle())
    ///             .frame(width: 30, height: 60)
    ///             .offset(y: -100)
    ///
    ///         ShapeMark(Rectangle())
    ///             .frame(width: 30, height: 60)
    ///             .offset(y: -100)
    ///             .coordinateRotation(angle: .degrees(50))
    ///     }
    /// }
    /// ```
    ///
    /// `GraphicsContext` 자체를 회전시킵니다. 이후 그려지는 모든 콘텐츠가 회전된 좌표계에서 그려집니다.
    ///
    /// ![An image of WatchContent in rotated coordinate system.](rotate_coordinate.png)
    func coordinateRotation(angle: Angle) -> some WatchContent {
        CoordinateRotatorContent(angle: angle, content: { self })
    }
    
    /// 콘텐츠의 원점(rect.origin)을 축으로 회전
    /// - Parameter angle: 회전 각도
    /// - Returns: 회전된 원점에서 그려지는 콘텐츠
    ///
    /// ```swift
    /// Watchface {
    ///     Layer(anchor: .center) {
    ///         TextMark(text: "º", anchor: .center)
    ///
    ///         Loop(data: 0..<6) { i in
    ///             TextMark(text: "\(i)", anchor: .center)
    ///                 .axisRotation(angle: .degrees(30.0 * Double(i))) // rect.point가 zero면 axis rotation이 동작하지 않음.
    ///                 .offset(x: -75)
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// 콘텐츠 origin을 원점 축 기준으로 회전합니다. \
    /// `GraphicsContext`는 변경하지 않고 rect의 origin 좌표만 회전 변환합니다.
    ///
    /// ![An image of WatchContent in rotated origin](rotate_axis.png)
    func axisRotation(angle: Angle) -> some WatchContent {
        AxisRotatorContent(angle: angle, content: { self })
    }
    
    /// 콘텐츠의 origin을 이동
    /// - Parameter offset: 이동 변위
    /// - Returns: 이동된 원점에서 그려지는 콘텐츠
    ///
    /// ```swift
    /// Watchface {
    ///     Layer(anchor: .center) {
    ///         TextMark(text: "center", anchor: .center)
    ///
    ///         TextMark(text: "offset y: -50", anchor: .center)
    ///             .offset(CGPoint(x: 0, y: -50))
    ///
    ///         TextMark(text: "offset x: -50, y: 50", anchor: .center)
    ///             .offset(CGPoint(x: -50, y: 50))
    ///     }
    /// }
    /// ```
    ///
    /// 콘텐츠의 X/Y 방향을 이동합니다.
    ///
    /// ![An image of WatchContent offset](offset.png)
    func offset(_ offset: CGPoint) -> some WatchContent {
        OffsetContent(offset: offset, content: { self })
    }
    
    /// 콘텐츠 origin을 이동
    /// - Parameters:
    ///   - x: 가로축 이동 변위
    ///   - y: 세로축 이동 변위
    /// - Returns: 이동된 원점에서 그려지는 콘텐츠
    ///
    /// ```swift
    /// Watchface {
    ///     Layer(anchor: .center) {
    ///         TextMark(text: "center", anchor: .center)
    ///
    ///         TextMark(text: "offset y: -50", anchor: .center)
    ///             .offset(y: -50)
    ///
    ///         TextMark(text: "offset x: -50, y: 50", anchor: .center)
    ///             .offset(x: -150, y: 50)
    ///     }
    /// }
    /// ```
    ///
    /// 콘텐츠의 X/Y 방향을 이동합니다.
    ///
    /// ![An image of WatchContent offset](offset.png)
    func offset(x: CGFloat = 0.0, y: CGFloat = 0.0) -> some WatchContent {
        OffsetContent(offset: CGPoint(x: x, y: y), content: { self })
    }
    
    /// 콘텐츠 크기에 균일 배율 적용
    /// - Parameter s: 크기 배율
    /// - Returns: 배율이 적용되어 그려지는 콘텐츠
    ///
    /// ```swift
    /// Watchface {
    ///     Layer {
    ///         ShapeMark(Circle())
    ///             .style(with: .color(.red))
    ///
    ///         ShapeMark(Circle())
    ///             .style(with: .color(.yellow))
    ///             .scale(0.8)
    ///
    ///         ShapeMark(Circle())
    ///             .style(with: .color(.blue))
    ///             .scale(0.6)
    ///     }
    /// }
    /// ```
    ///
    /// 콘텐츠 사이즈 크기를 X/Y 독립적으로 배율 변환합니다.
    ///
    /// ![An image of WatchContent scaled out by single value](scale_2.png)
    func scale(_ s: CGFloat) -> some WatchContent {
        ScaleContent(CGSize(width: s, height: s), content: { self })
    }

    /// 콘텐츠 크기에 균일 배율 적용
    /// - Parameter scale: 가로, 세로 크기 배율
    /// - Returns: 배율이 적용되어 그려지는 콘텐츠
    ///
    /// ```swift
    /// Watchface {
    ///     Layer {
    ///         ShapeMark(Rectangle())
    ///             .frame(width: 100, height: 50)
    ///
    ///         ShapeMark(Rectangle())
    ///             .style(with: .color(.brown))
    ///             .scale(CGSize(width: 2, height: 0.5))
    ///             .frame(width: 100, height: 50)
    ///     }
    /// }
    /// ```
    ///
    /// 콘텐츠 사이즈 크기를 X/Y 독립적으로 배율 변환합니다.
    ///
    /// ![An image of WatchContent scaled out by CGSize](scale_1.png)
    func scale(_ scale: CGSize) -> some WatchContent {
        ScaleContent(scale, content: { self })
    }
    /// 콘텐츠 크기를 명시적으로 지정
    /// - Parameters:
    ///   - width: 콘텐츠 너비, nil이면 부모 콘텐츠 너비
    ///   - height: 콘텐츠 높이, nil이면 부모 콘텐츠 높이
    /// - Returns: 크기가 명시되어 그려지는 콘텐츠
    ///
    /// ```swift
    /// Watchface {
    ///     Layer(anchor: .center) {
    ///         ShapeMark(Rectangle())
    ///             .frame(width: 100, height: 30)
    ///
    ///         ShapeMark(Rectangle(), anchor: .topLeading)
    ///             .style(with: .color(.orange))
    ///             .offset(y: 100)
    ///             .frame(height: 30)
    ///     }
    /// }
    /// ```
    ///
    /// 자식 콘텐츠에 전달되는 `rect`의 width/height를 명시적으로 지정합니다.
    ///
    /// ![A image with the two types: non frame modified, frame modified](frame.png)
    func frame(width: CGFloat? = nil, height: CGFloat? = nil) -> some WatchContent {
        FrameContent(width: width, height: height, content: { self })
    }
    
    /// 콘텐츠 width 기준으로 height를 비율로 결정
    /// - Parameter aspectRatio: 너비 / 높이 비율
    /// - Returns: 비율이 적용되어 그려지는 콘텐츠
    ///
    /// ```swift
    ///Watchface {
    ///    Layer(anchor: .center) {
    ///        ShapeMark(Rectangle())
    ///            .aspectRatio(1.0 / 2.0) // width : height = 1 : 2
    ///            .frame(width: 50, height: 500) // aspect ratio가 설정되면 height는 무시됨.
    ///    }
    ///}
    /// ```
    ///
    /// 콘텐츠 width를 기준으로 height = width / aspectRatio를 계산합니다.
    ///
    /// ![An image of WatchContent applied size of aspect raio](aspect_ratio.png)
    func aspectRatio(_ aspectRatio: CGFloat) -> some WatchContent {
        AspectRatioContent(aspectRatio: aspectRatio, content: { self })
    }
    
    /// 콘텐츠의 불투명도 설정
    /// - Parameter opacity: 0부터 1사이 불투명도 값
    /// - Returns: 불투명도가 적용되어 그려지는 콘텐츠
    ///
    /// ```swift
    /// Watchface {
    ///     Layer(anchor: .top) {
    ///         ShapeMark(Rectangle(), anchor: .top)
    ///             .style(with: .color(.purple))
    ///             .frame(width: 200, height: 100)
    ///
    ///         TextMark(text: "opacity: 100%", anchor: .center)
    ///             .offset(y: 50)
    ///     }
    ///
    ///     Layer(anchor: .center) {
    ///         ShapeMark(Rectangle())
    ///             .style(with: .color(.purple))
    ///             .frame(width: 200, height: 100)
    ///             .opacity(0.4)
    ///
    ///         TextMark(text: "opacity: 40%", anchor: .center)
    ///     }
    /// }
    /// ```
    ///
    /// ---
    ///
    /// 불투명도 적용
    ///
    /// ![An image of WatchContent applied opacity ratio](opacity.png)
    func opacity(_ opacity: Double) -> some WatchContent {
        OpacityContent(opacity: opacity, content: { self })
    }
}
