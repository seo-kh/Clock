//
//  Size.swift
//  WatchUI
//
//  Created by alphacircle on 2/24/26.
//

import Foundation
import CoreGraphics

public struct Size {
    let x: SizeRule
    let y: SizeRule
    let width: SizeRule
    let height: SizeRule

    public init(x: SizeRule = .fixed(0), y: SizeRule = .identity, width: SizeRule = .identity, height: SizeRule = .identity) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }
    
    public func makeCGRect(length: CGFloat) -> CGRect {
        let _x = x.transform(from: length)
        let _y = y.transform(from: length)
        let _width = width.transform(from: length)
        let _height = height.transform(from: length)
        return CGRect(x: -_x, y: -_y, width: _width, height: _height)
    }
}
