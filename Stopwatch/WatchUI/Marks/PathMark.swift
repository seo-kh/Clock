//
//  PathMark.swift
//  WatchUI
//
//  Created by alphacircle on 2/9/26.
//

import SwiftUI

public struct PathMark: WatchContent {
    let path: Path
    var shading: GraphicsContext.Shading
    var style: FillStyle
    
    public init(_ path: Path) {
        self.path = path
        self.shading = GraphicsContext.Shading.foreground
        self.style = FillStyle()
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        context.fill(self.path, with: self.shading, style: self.style)
    }
}

// MARK: - Modifiers
public extension PathMark {
    
    func apply(_ shading: GraphicsContext.Shading) -> Self {
        var _self = self
        _self.shading = shading
        return _self
    }
    
    func apply(_ style: FillStyle) -> Self {
        var _self = self
        _self.style = style
        return _self
    }
}
