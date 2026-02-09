//
//  ImageMark.swift
//  WatchUI
//
//  Created by alphacircle on 2/9/26.
//

import SwiftUI

public struct ImageMark: WatchContent {
    let image: Image
    
    public init(_ image: Image) {
        self.image = image
    }
    
    public var body: Never {
        fatalError("ImageMark is a primitive content.")
    }
}

#Preview {
    Watchface {
        ImageMark(Image(systemName: "circle"))
    }
}
