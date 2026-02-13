//
//  ParameterPackTests.swift
//  StopwatchTests
//
//  Created by alphacircle on 2/13/26.
//

import Testing
import Foundation

struct NotEqual: Error {}
func == <each Element: Equatable>(lhs: (repeat each Element), rhs: (repeat each Element)) -> Bool {
    for (left, right) in repeat (each lhs, each rhs) {
        guard left == right else { return false }
    }
    return true
}

func printEach<each Element>(_ values: (repeat each Element)) {
    for element in repeat (each values) {
        print(element)
    }
}

func allEmpty<each T>(_ arrry: repeat [each T]) -> Bool {
    for a in repeat each arrry {
        guard a.isEmpty else { return false }
    }
    return true
}

protocol ValueProducer {
    associatedtype Value: Codable
    func evaluate() -> Value
}

func evaluateAll<each T: ValueProducer, each E: Error>(result: repeat Result<each T, each E>) -> [any Codable] {
    var evaluated: [any Codable] = []
    for case .success(let valueProducer) in repeat each result {
        evaluated.append(valueProducer.evaluate())
    }
    return evaluated
}

struct ParameterPackTests {
    @Test
    func testPrintEach() async throws {
        let values  = ("a", 1, 30.4, true)
        printEach(values)
    }
    
    @Test("testPackIteration")
    func testAllEmpty() async throws {
        let isEmpty = allEmpty(["one", "two"], [1], [true, false], [])
        #expect(!isEmpty)
    }

}
