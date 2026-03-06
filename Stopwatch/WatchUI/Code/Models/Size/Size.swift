//
//  Size.swift
//  WatchUI
//
//  Created by alphacircle on 2/24/26.
//

import Foundation
import CoreGraphics

/// 사이즈 룰 컨테이너
///
/// 콘텐츠의 원점과 크기 변환 룰을 담는 컨테이너
public struct Size {
    let x: SizeRule
    let y: SizeRule
    let width: SizeRule
    let height: SizeRule

    /// 기본 이니셜라이저
    ///
    /// - Parameters:
    ///   - x: x 오프셋 룰
    ///   - y: y 오프셋 룰
    ///   - width: 너비 룰
    ///   - height: 높이 룰
    public init(x: SizeRule = .fixed(0), y: SizeRule = .identity, width: SizeRule = .identity, height: SizeRule = .identity) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }
    
    /// 기준 크기를 변환한 rect 반환
    /// 
    /// - Parameter original: 기준 크기
    /// - Returns: rect
    ///
    /// * 각 ``SizeRule``에 `length`를 전달하여 변환
    /// * 변환후, CGRect를 반환
    public func makeCGRect(from original: CGFloat) -> CGRect {
        let _x = x.transform(from: original)
        let _y = y.transform(from: original)
        let _width = width.transform(from: original)
        let _height = height.transform(from: original)
        return CGRect(x: -_x, y: -_y, width: _width, height: _height)
    }
}
