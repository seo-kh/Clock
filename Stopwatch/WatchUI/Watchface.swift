//
//  Watchface.swift
//  WatchUI
//
//  Created by alphacircle on 2/6/26.
//

import SwiftUI

public struct Watchface<Content: WatchContent>: View {
    let content: () -> Content
    
    public init(@WatchContentBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        Canvas { (context, size) in
            let rect = CGRect(origin: CGPoint.zero, size: size)
            
            content()
                .render(&context, rect: rect)
        }
    }
}

