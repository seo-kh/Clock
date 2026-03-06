//
//  StopwatchStyle.swift
//  Stopwatch
//
//  Created by james seo on 2/3/26.
//

import SwiftUI

protocol StopwatchStyle {
    func style(with shading: GraphicsContext.Shading) -> Self
}
