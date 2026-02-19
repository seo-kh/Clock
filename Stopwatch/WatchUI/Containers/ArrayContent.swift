//
//  ArrayContent.swift
//  WatchUI
//
//  Created by alphacircle on 2/19/26.
//

import Foundation
import SwiftUI

public struct ArrayContent: WatchContent {
    let contents: [any WatchContent]
    
    var count: Int {
        contents.count
    }
    
    init(repeating value: any WatchContent, count: Int) {
        let contents: [any WatchContent] = Array(repeating: value, count: count)
        self.init(contents: contents)
    }
    
    init(contents: [any WatchContent]) {
        self.contents = contents
    }
    
    init<each Content: WatchContent>(_ contents: (repeat each Content)) {
        var _contents: [any WatchContent] = []
        for content in repeat each contents {
            _contents.append(content)
        }
        self.init(contents: _contents)
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        for content in contents {
            content.render(&context, rect: rect)
        }
    }
}
