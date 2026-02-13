//
//  Layer.swift
//  WatchUI
//
//  Created by alphacircle on 2/12/26.
//

import Foundation

public struct Layer<Content: WatchContent>: WatchContent {
    let alignment: Alignment
    let content: () -> Content
    
    public init(alignment: Alignment = .center, @WatchContentBuilder content: @escaping () -> Content) {
        self.alignment = alignment
        self.content = content
    }
    
    public var body: some WatchContent {
        content()
    }
}

public extension Layer {
    enum Alignment {
        case leading
        case center
        case trailing
    }
}
