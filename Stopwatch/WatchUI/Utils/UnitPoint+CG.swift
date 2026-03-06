//
//  UnitPoint+CG.swift
//  WatchUI
//
//  Created by alphacircle on 2/25/26.
//

import SwiftUI

extension UnitPoint {
    /// anchor에 따른 이동 좌표 계산
    ///
    /// - Parameter rect: 기준 rect
    /// - Returns: 위치 조정된 origin
    ///
    /// > aligned origin = origin + (size.width × anchor.x, size.height × anchor.y)
    func alignOriginPoint(to rect: CGRect) -> CGPoint {
        // origin
        let origin = rect.origin
        
        // delta x, delta y
        let sTransform = CGAffineTransform(scaleX: self.x, y: self.y)
        let sSize = rect.size.applying(sTransform)
        
        // translate origin
        let tTransform = CGAffineTransform(translationX: sSize.width, y: sSize.height)
        let alignedOrigin = origin.applying(tTransform)
        
        return alignedOrigin
    }
    
    /// rect 내의 anchor 기준점 정렬
    ///
    /// - Parameter rect: 기준 rect
    /// - Returns: 위치 조정된 rect
    ///
    /// > aligned origin = origin - (size.width x anchor.x, size.height x anchor.y)
    ///
    /// SwiftUI 좌표계는 top-leading이 원점(0, 0)이기 때문에, anchor에 따른 origin은 (-) 계산을 취해야한다.
    func alignAnchorPoint(to rect: CGRect) -> CGRect {
        // origin
        let origin = rect.origin
        let size = rect.size
        
        // delta x, delta y
        let sTransform = CGAffineTransform(scaleX: self.x, y: self.y)
        let sSize = size.applying(sTransform)
        
        // translate origin
        let tTransform = CGAffineTransform(translationX: -sSize.width, y: -sSize.height) // top-leading 방향으로 이동해야함. 따라서 (-) 사용
        let alignedOrigin = origin.applying(tTransform)
     
        return CGRect(origin: alignedOrigin, size: size)
    }
}
