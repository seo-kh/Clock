//
//  WatchUITests.swift
//  WatchUITests
//
//  Created by alphacircle on 2/12/26.
//

import Testing
import SwiftUI
@testable import WatchUI

struct WatchUITests {
    @Test("WatchFace가 WatchContent tree를 잘 해석할수 있는지 테스트")
    func test1() async throws {
        let text1 = TextMark("1")
        let text2 = TextMark("2")
        let text3 = TextMark("3")
        let text4 = TextMark("4")
        let layer = Layer(alignment: .leading) {
            text2
            text3
            text4
        }
        let tuple = TupleContent((layer, text1))
        interpret(tuple)
    }
    
    func interpret<each T: WatchContent>(_ contents: repeat each T) {
        for content in repeat each contents {
            let _type = type(of: content)
            print(_type)
            
            if type(of: content.self.body) == Never.self {
                print("never")
            } else {
                interpret(content.body)
            }
        }
    }
}
