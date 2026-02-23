//
//  AnyWatchContent.swift
//  WatchUI
//
//  Created by alphacircle on 2/19/26.
//

import SwiftUI

public struct AnyWatchContent: WatchContent {
    let content: any WatchContent
    
    public init(content: any WatchContent) {
        self.content = content
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        content
            .render(&context, rect: rect)
    }
}
