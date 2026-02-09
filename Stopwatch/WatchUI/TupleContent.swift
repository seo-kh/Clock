//
//  TupleContent.swift
//  WatchUI
//
//  Created by alphacircle on 2/6/26.
//

import Foundation

public struct TupleContent<T>: WatchContent where T: WatchContent {
    var value: T
    
    public init(_ value: T) {
        self.value = value
    }
    
    public var body: some WatchContent {
        self
    }
}
