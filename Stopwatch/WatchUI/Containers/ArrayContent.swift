//
//  ArrayContent.swift
//  WatchUI
//
//  Created by alphacircle on 2/19/26.
//

import Foundation
import SwiftUI

public struct ArrayContent: WatchContent {
    var contents: [Element]
    
    typealias Element = (index: Int, body: any WatchContent)
    
    public var count: Int {
        contents.count
    }
    
    public init(contents: [any WatchContent]) {
        self.contents = contents
            .enumerated()
            .map({ ($0, $1) })
    }
    
    public init<each Content: WatchContent>(_ contents: (repeat each Content)) {
        var _contents: [any WatchContent] = []
        
        for content in repeat each contents {
            _contents.append(content)
        }
        
        self.init(contents: _contents)
    }
    
    func map<E>(_ transform: (Element) throws(E) -> any WatchContent) -> Self where E: Error {
        do {
            let newContents = try contents.map(transform)
            return Self(contents: newContents)
        } catch {
            return self
        }
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        for content in contents {
            content.body.render(&context, rect: rect)
        }
    }
}
