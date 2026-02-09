//
//  TextMark.swift
//  WatchUI
//
//  Created by alphacircle on 2/6/26.
//

import SwiftUI

public struct TextMark: WatchContent {
    let text: Text
    
    public init(_ text: Text) {
        self.text = text
    }
    
    public init(_ text: String) {
        self.text = Text(text)
    }
    
    public var body: Never {
        fatalError("TextMark is a primitive content.")
    }
}

#Preview("test: one mark render") {
    Watchface {
        TextMark("Hi")
    }
}
