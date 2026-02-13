//
//  TextMark.swift
//  WatchUI
//
//  Created by alphacircle on 2/6/26.
//

import SwiftUI

public struct TextMark: WatchContent, PrimitiveContent {
    let value: Text
    
    public init(_ text: Text) {
        self.value = text
    }
    
    public init(_ text: String) {
        self.value = Text(text)
    }
    
    public typealias Body = Never
}

#Preview("test: one mark render") {
    Watchface {
        TextMark("Hi")
    }
}
