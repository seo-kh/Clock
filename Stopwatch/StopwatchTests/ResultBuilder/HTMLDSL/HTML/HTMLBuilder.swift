//
//  HTMLBuilder.swift
//  StopwatchTests
//
//  Created by alphacircle on 2/6/26.
//

import Foundation

@resultBuilder
struct HTMLBuilder {
    static func buildBlock(_ components: HTMLNode...) -> [HTMLNode] {
        Array(components)
    }
    
    static func buildOptional(_ component: [HTMLNode]?) -> [HTMLNode] {
        component ?? []
    }
    
    static func buildEither(first component: [HTMLNode]) -> [HTMLNode] {
        component
    }
    
    static func buildEither(second component: [HTMLNode]) -> [HTMLNode] {
        component
    }
    
    static func buildArray(_ components: [[HTMLNode]]) -> [HTMLNode] {
        components.flatMap({ $0 })
    }
    
    static func buildExpression(_ expression: HTMLNode) -> [HTMLNode] {
        [expression]
    }
    
    static func buildExpression(_ expression: String) -> [HTMLNode] {
        [HTMLNode(tag: "text", content: expression)]
    }
}
