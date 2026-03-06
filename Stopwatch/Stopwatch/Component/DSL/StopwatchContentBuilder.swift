//
//  StopwatchContentBuilder.swift
//  Stopwatch
//
//  Created by james seo on 2/3/26.
//

import Foundation

@resultBuilder
enum StopwatchContentBuilder {
    static func buildBlock<Content: StopwatchContent>(_ components: Content...) -> [Content] {
        components
    }
}
