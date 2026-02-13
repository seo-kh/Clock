//
//  ImageMark.swift
//  WatchUI
//
//  Created by alphacircle on 2/9/26.
//

import SwiftUI

public struct ImageMark: WatchContent, PrimitiveContent {
    let value: Image
    
    public init(_ image: Image) {
        self.value = image
    }
    
    public typealias Body = Never
}

#Preview {
    Watchface {
        ImageMark(Image(systemName: "circle"))
    }
}
