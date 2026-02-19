//
//  AnyWatchContent.swift
//  WatchUI
//
//  Created by alphacircle on 2/19/26.
//

import SwiftUI

struct AnyWatchContent: WatchContent {
    let content: any WatchContent
    
    func render(_ context: inout GraphicsContext, rect: CGRect) {
        content
            .render(&context, rect: rect)
    }
}
