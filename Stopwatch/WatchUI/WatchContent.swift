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

protocol PrimitiveContent {
    associatedtype Value
    var value: Value { get }
}

public extension WatchContent where Self.Body == Never {
    var body: Never {
        fatalError("이 타입은 최하위 뷰이므로 body를 가질 수 없습니다.")
    }
}
