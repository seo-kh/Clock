//
//  UnitPoint+CG.swift
//  WatchUI
//
//  Created by alphacircle on 2/25/26.
//

import SwiftUI

extension UnitPoint {
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
