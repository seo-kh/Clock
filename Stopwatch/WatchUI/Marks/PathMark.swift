//
//  PathMark.swift
//  WatchUI
//
//  Created by alphacircle on 2/9/26.
//

import SwiftUI

public struct PathMark: WatchContent, PrimitiveContent {
    let value: Path
    
    public init(_ path: Path) {
        self.value = path
    }
    
    public init(_ shape: any Shape, rect: CGRect) {
        self.value = shape.path(in: rect)
    }
    
    public typealias Body = Never
}

