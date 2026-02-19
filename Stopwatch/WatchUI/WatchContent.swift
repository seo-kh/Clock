//
//  WatchContent.swift
//  WatchUI
//
//  Created by alphacircle on 2/6/26.
//

import SwiftUI

public protocol WatchContent {
    func render(_ context: inout GraphicsContext, rect: CGRect)
}

