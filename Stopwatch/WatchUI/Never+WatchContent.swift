//
//  Never+WatchContent.swift
//  WatchUI
//
//  Created by alphacircle on 2/9/26.
//

import Foundation

extension Never: WatchContent {
    public var body: Never {
        fatalError("Never is a primitive type.")
    }
}
