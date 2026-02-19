//
//  WatchContentBuilder.swift
//  WatchUI
//
//  Created by alphacircle on 2/6/26.
//

import Foundation

@resultBuilder
public struct WatchContentBuilder {
    public static func buildBlock<Content>(_ content: Content) -> ArrayContent where Content: WatchContent {
        return ArrayContent(content)
    }
    
    public static func buildBlock<each Content: WatchContent>(_ contents: repeat each Content) -> ArrayContent {
        return ArrayContent((repeat each contents))
    }
    
    public static func buildExpression<Content>(_ content: Content) -> ArrayContent where Content: WatchContent {
        return ArrayContent(content)
    }
}
