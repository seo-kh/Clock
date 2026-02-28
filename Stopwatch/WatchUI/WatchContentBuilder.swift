//
//  WatchContentBuilder.swift
//  WatchUI
//
//  Created by alphacircle on 2/6/26.
//

import Foundation

@resultBuilder
public struct WatchContentBuilder {
    public static func buildBlock() -> EmptyContent {
        return EmptyContent()
    }
    
    public static func buildBlock<Content>(_ content: Content) -> Content where Content: WatchContent {
        return content
    }
    
    public static func buildBlock<each Content>(_ content: repeat each Content) -> TupleContent<(repeat each Content)> where repeat each Content: WatchContent {
        return TupleContent(contents: (repeat each content))
    }
    
    public static func buildExpression<Content>(_ content: Content) -> Content where Content: WatchContent {
        return content
    }
}
