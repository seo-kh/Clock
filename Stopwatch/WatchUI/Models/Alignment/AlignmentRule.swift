//
//  AlignmentRule.swift
//  WatchUI
//
//  Created by alphacircle on 2/25/26.
//

import Foundation
import SwiftUI

protocol AlignmentRule {
    var anchor: UnitPoint { get }
}

extension AlignmentRule {
    func alignOrigin(to rect: CGRect) -> CGPoint {
        // origin
        let origin = rect.origin
        
        // delta x, delta y
        let sTransform = CGAffineTransform(scaleX: anchor.x, y: anchor.y)
        let sSize = rect.size.applying(sTransform)
        
        // translate origin
        let tTransform = CGAffineTransform(translationX: sSize.width, y: sSize.height)
        let alignedOrigin = origin.applying(tTransform)
        
        return alignedOrigin
    }
    
    func _alignAnchor(to rect: CGRect) -> CGRect {
        // origin
        let origin = rect.origin
        let size = rect.size
        
        // delta x, delta y
        let sTransform = CGAffineTransform(scaleX: anchor.x, y: anchor.y)
        let sSize = size.applying(sTransform)
        
        // translate origin
        let tTransform = CGAffineTransform(translationX: -sSize.width, y: -sSize.height) // top-leading 방향으로 이동해야함. 따라서 (-) 사용
        let alignedOrigin = origin.applying(tTransform)
        
        return CGRect(origin: alignedOrigin, size: size)
    }

    func alignAnchor(to rect: inout CGRect) {
        let minX = 0.0
        let minY = 0.0
        let midX = rect.width / 2.0
        let midY = rect.height / 2.0
        let maxX = rect.width
        let maxY = rect.height
        
        switch anchor {
        case .topLeading: rect.origin.x += -minX; rect.origin.y += -minY
        case .top: rect.origin.x += -midX; rect.origin.y += -minY
        case .topTrailing: rect.origin.x += -maxX; rect.origin.y += -minY
        case .leading: rect.origin.x += -minX; rect.origin.y += -midY
        case .center: rect.origin.x += -midX; rect.origin.y += -midY
        case .trailing: rect.origin.x += -maxX; rect.origin.y += -midY
        case .bottomLeading: rect.origin.x += -minX; rect.origin.y += -maxY
        case .bottom: rect.origin.x += -midX; rect.origin.y += -maxY
        case .bottomTrailing: rect.origin.x += -maxX; rect.origin.y += -maxY
        default: break
        }
    }

    
//    func alignAnchor(to rect: CGRect) -> CGPoint {
//        let minX = 0.0
//        let minY = 0.0
//        let midX = rect.width / 2.0
//        let midY = rect.height / 2.0
//        let maxX = rect.width
//        let maxY = rect.height
//        
//        return switch anchor {
//        case .topLeading: CGPoint(x: minX, y: minY)
//        case .top: CGPoint(x: midX, y: minY)
//        case .topTrailing: CGPoint(x: maxX, y: minY)
//        case .leading: CGPoint(x: minX, y: midY)
//        case .center: CGPoint(x: midX, y: midY)
//        case .trailing: CGPoint(x: maxX, y: midY)
//        case .bottomLeading: CGPoint(x: minX, y: maxY)
//        case .bottom: CGPoint(x: midX, y: maxY)
//        case .bottomTrailing: CGPoint(x: maxX, y: maxY)
//        default: CGPoint.zero
//        }
//    }
    
//    func alignRect(to rect: CGRect) -> CGRect {
//        let point = self.alignOrigin(to: rect)
//        
//        var newRect = rect
//        newRect.origin.x += -point.x
//        newRect.origin.y += -point.y
//
//        return newRect
//    }
}
