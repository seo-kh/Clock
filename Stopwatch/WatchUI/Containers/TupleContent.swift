//
//  TupleContent.swift
//  WatchUI
//
//  Created by 테스트 on 2/28/26.
//

import Foundation
import SwiftUI

public struct TupleContent<T>: WatchContent {
    public var value: T
    private var execute: ((inout GraphicsContext, CGRect) -> Void)?
    
    public init(_ value: T) {
        self.value = value
        self.execute = nil
    }
    
    init<each Content: WatchContent>(contents: (repeat each Content)) where T == (repeat each Content) {
        self.value = contents
        self.execute = self._render(_:rect:)
    }
    
    private func _render<each Content: WatchContent>(_ context: inout GraphicsContext, rect: CGRect) where T == (repeat each Content) {
        for content in repeat each value {
            content
                .render(&context, rect: rect)
        }
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        execute?(&context, rect)
    }
}
