//
//  WatchContent.swift
//  WatchUI
//
//  Created by alphacircle on 2/6/26.
//

import Foundation

public protocol WatchContent {
    associatedtype Body: WatchContent
    @WatchContentBuilder var body: Self.Body { get }
}
