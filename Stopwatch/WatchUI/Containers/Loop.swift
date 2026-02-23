//
//  Loop.swift
//  WatchUI
//
//  Created by alphacircle on 2/23/26.
//

import Foundation
import SwiftUI

public struct Loop<Data, Content>: WatchContent where Data: RandomAccessCollection, Content: WatchContent {
    let data: Data
    let content: (Data.Element) -> Content
    
    public var count: Int {
        data.count
    }
    
    public init(data: Data, content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
    }
    
    public func render(_ context: inout GraphicsContext, rect: CGRect) {
        for element in data {
            content(element)
                .render(&context, rect: rect)
        }
    }
}
