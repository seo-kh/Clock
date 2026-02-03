//
//  StopwatchContentBuilder.swift
//  Stopwatch
//
//  Created by alphacircle on 2/3/26.
//

import Foundation

@resultBuilder
enum StopwatchContentBuilder {
    static func buildBlock<Content: StopwatchContent>(_ components: Content...) -> [Content] {
        components
    }
}
