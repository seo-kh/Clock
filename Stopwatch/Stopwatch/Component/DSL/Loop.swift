//
//  Loop.swift
//  Stopwatch
//
//  Created by alphacircle on 2/3/26.
//

import SwiftUI

struct Loop<Data, Content>: StopwatchContent where Data: RandomAccessCollection, Content: StopwatchContent, Data.Element: Hashable {
    var data: Data
    var content: (Data.Element) -> Content
    private var rect: CGRect

    init(_ data: Data,
         content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
        self.rect = CGRect.zero
    }
    
    
    func draw(_ context: inout GraphicsContext) {
        for element in data {
            content(element)
                .bound(rect)
                .draw(&context)
        }
    }
    
    func bound(_ rect: CGRect) -> Self {
        var _self = self
        _self.rect = rect
        return _self
    }
}
