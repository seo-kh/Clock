//
//  PathMark.swift
//  WatchUI
//
//  Created by alphacircle on 2/9/26.
//

import SwiftUI

public struct PathMark: WatchContent {
    let path: Path
    
    public init(_ path: Path) {
        self.path = path
    }
    
    public init(_ shape: any Shape, rect: CGRect) {
        self.path = shape.path(in: rect)
    }
    
    public var body: Never {
        fatalError("PathMark is a primitive content.")
    }
}

