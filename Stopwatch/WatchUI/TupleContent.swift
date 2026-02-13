//
//  TupleContent.swift
//  WatchUI
//
//  Created by alphacircle on 2/6/26.
//

import Foundation

public struct TupleContent<T>: WatchContent, PrimitiveContent {
    public var value: T
    
    public init(_ value: T) {
        self.value = value
    }
    
    public typealias Body = Never
}

extension TupleContent {
    func emit<each Element: WatchContent>() -> Array<any WatchContent> where T == (repeat each Element) {
        var result: Array<any WatchContent> = []
        for content in repeat each value {
            result.append(content)
        }
        return result
    }
}
