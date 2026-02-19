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
    var fillStyle: FillStyle
    
    public init(_ path: Path) {
        self.path = path
        self.shading = GraphicsContext.Shading.foreground
        self.fillStyle = FillStyle()
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        context.fill(self.path, with: self.shading, style: self.fillStyle)
    }
}

// MARK: - Modifiers
public extension PathMark {
    func style(with shading: GraphicsContext.Shading, fillStyle: FillStyle = FillStyle()) -> Self {
        var _self = self
        _self.shading = shading
        _self.fillStyle = fillStyle
        return _self
    }
}
