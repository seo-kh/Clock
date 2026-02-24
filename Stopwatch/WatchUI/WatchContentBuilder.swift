//
//  WatchContentBuilder.swift
//  WatchUI
//
//  Created by alphacircle on 2/6/26.
//

import Foundation

@resultBuilder
public struct WatchContentBuilder {
    public static func buildBlock<Content>(_ content: Content) -> some WatchContent where Content: WatchContent {
        return content
    }
    
    public static func buildBlock<each Content: WatchContent>(_ contents: repeat each Content) -> some WatchContent {
        return ArrayContent((repeat each contents))
    }
    
    public static func buildExpression<Content>(_ content: Content) -> some WatchContent where Content: WatchContent {
        return content
    }
}
