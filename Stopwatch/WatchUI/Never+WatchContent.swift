//
//  Never+WatchContent.swift
//  WatchUI
//
//  Created by alphacircle on 2/9/26.
//

import Foundation

extension Never: WatchContent {
    public typealias Body = Never
    public var body: Never {
        fatalError("Never has no body")
    }
}
