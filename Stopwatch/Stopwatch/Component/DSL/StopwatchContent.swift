//
//  StopwatchContent.swift
//  Stopwatch
//
//  Created by james seo on 2/3/26.
//

import SwiftUI

protocol StopwatchContent {
    func draw(_ context: inout GraphicsContext)
    func bound(_ rect: CGRect) -> Self
}
