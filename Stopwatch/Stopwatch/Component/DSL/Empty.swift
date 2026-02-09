//
//  Empty.swift
//  Stopwatch
//
//  Created by alphacircle on 2/3/26.
//

import SwiftUI
import WatchUI

struct Empty: StopwatchContent {
    func draw(_ context: inout GraphicsContext) {
        
    }
    
    func bound(_ rect: CGRect) -> Empty {
        self
    }
}

struct Test: WatchContent {
    var body: some WatchContent {
        WatchUI.Mark(shape: Path(ellipseIn: .zero))
            
    }
}
