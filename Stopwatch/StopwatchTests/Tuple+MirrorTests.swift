//
//  Tuple+MirrorTests.swift
//  StopwatchTests
//
//  Created by alphacircle on 2/12/26.
//

import Testing

protocol whatever {}

struct A: whatever {
    let int: Int = 9
    let string: String = "a"
    let double: Double = 2.97
    let bool: Bool = true
}

struct B: whatever {
    let hi = "Hi"
    let hey = 3
    let ho = 9.77
}

struct Tuple_MirrorTests {

    @Test
    func test1() async throws {
        let data = (0, "1", 2.0, true)
        let mirror = Mirror(reflecting: data)
        
        print("mirror", mirror)
        for child in mirror.children {
            print("child", child)
        }
        
        var children = mirror.children
        
        while(!children.isEmpty) {
            let child = children.removeFirst()
            print("child2", child)
        }
        print("children", children.isEmpty)
    }

    @Test("struct mirror")
    func test2() async throws {
        let data = (A(), B())
        let mirror = Mirror(reflecting: data)
        var children = mirror.children
        
        while(!children.isEmpty) {
            let child = children.removeFirst()
            
            switch child.value {
            case let what as whatever:
                print("what", what)
            case let a as A:
                print("a", a)
            case let b as B:
                print("b", b)
            default:
                print("none")
            }
        }
        
        print(children.isEmpty)
    }
}
