//
//  CombineTests.swift
//  StopwatchTests
//
//  Created by alphacircle on 1/19/26.
//

import Testing
import Combine
import Foundation

struct CombineTests {
    
    @Suite("Mapping elements")
    struct MappingOperators {
        /// Transforms all elements from the upstream publisher with a provided closure.
        @Test("map")
        func test1() async throws {
            let numbers = [5, 4, 3, 2, 1, 0]
            let romanianNumberDict: [Int: String] = [
                1: "I",
                2: "II",
                3: "III",
                4: "IV",
                5: "V"
            ]
            
            let _ = numbers.publisher
                .map({ romanianNumberDict[$0] ?? "(unknown)" })
                .sink { roman in
                    print(roman)
                }
            
        }
        
        /// Transforms all elements from the upstream publisher with a provided error-throwing closure.
        @Test("tryMap")
        func test2() async throws {
            struct ParseError: Error {}
            func romanNumeral(from: Int) throws -> String {
                let romanNumberDict: [Int: String] = [
                    1: "I",
                    2: "II",
                    3: "III",
                    4: "IV",
                    5: "V"
                ]
                guard let numeral = romanNumberDict[from] else {
                    throw ParseError()
                }
                return numeral
            }
            
            let numbers = [5, 4, 3, 8, 2, 1, 0]
            let _ = numbers.publisher
                .tryMap { i in
                    try romanNumeral(from: i)
                }
                .sink(receiveCompletion: { print("completion: \($0)")},
                      receiveValue: { print("\($0)") })
        }
        
        /// Converts any failure from the upstream publisher into a new error.
        @Test("mapError")
        func test3() async throws {
            struct DivisionByZeroError: Error {}
            struct MyGenericError: Error { var wrappedError: Error }
            
            func myDivide(_ dividend: Double, _ divisor: Double) throws -> Double {
                guard divisor != 0 else { throw DivisionByZeroError() }
                return dividend / divisor
            }
            
            let divisors: [Double] = [5, 4, 3, 2, 1, 0]
            let _ = divisors.publisher
                .tryMap({ try myDivide(1, $0) })
                .mapError({ MyGenericError(wrappedError: $0) })
                .sink(receiveCompletion: { print("Completion: \($0)") },
                      receiveValue: { print("Value: \($0)", terminator: " ")})
        }
        
        /// Replaces nil elements in the stream with the provided element.
        @Test("replaceNil(with:)")
        func test4() async throws {
            let numbers: [Double?] = [1.0, 2.0, nil, 3.0]
            let _ = numbers
                .publisher
                .replaceNil(with: 0.0)
                .sink(receiveValue: { print("\($0)", terminator: " ")})
        }
        
        /// Transforms elements from the upstream publisher by providing the current element to a closure along with the last value returned by the closure.
        @Test("scan(_:_:)")
        func test5() async throws {
            let range = (0...5)
            let _ = range.publisher
                .scan(5, { return $0 + $1 })
                .sink(receiveValue: { print("\($0)", terminator: " ")})
        }
        
        /// Transforms elements from the upstream publisher by providing the current element to an error-throwing closure along with the last value returned by the closure.
        @Test("tryScan(_:_:)")
        func test6() async throws {
            struct DivisionByZeroError: Error {}
            func myThrowingFunction(_ lastValue: Int, _ currentValue: Int) throws -> Int {
                guard currentValue != 0 else { throw DivisionByZeroError() }
                return (lastValue + currentValue) / currentValue
            }
            
            let numbers = [1, 2, 3, 4, 5,0, 6,7,8,9]
            let _ = numbers.publisher
                .tryScan(10, { try myThrowingFunction($0, $1) })
                .sink(receiveCompletion: { print("\($0)") },
                      receiveValue: { print("\($0)", terminator: " ") })
        }
        
        /// Changes the failure type declared by the upstream publisher.
        @Test("setFailureType(to:)")
        func test7() async throws {
            let pub1 = [0, 1, 2, 3, 4, 5].publisher
            let pub2 = CurrentValueSubject<Int, Error>(0)
            let _ = pub1
                .setFailureType(to: Error.self)
                .combineLatest(pub2)
                .sink(receiveCompletion: { print("completed: \($0)" )},
                      receiveValue: { print("value: \($0)") })
            
            pub2.send(4)
            pub2.send(8)
            pub2.send(7)
            pub2.send(4)
        }
    }
    
    @Suite("Filtering elements")
    struct FilteringOperators {
        /// Republishes all elements that match a provided closure.
        @Test("filter(_:)")
        func test1() async throws {
            let numbers = [1, 2, 3, 4, 5]
            let _ = numbers.publisher
                .filter({ $0 % 2 == 0 })
                .sink(receiveValue: { print("\($0)", terminator: " ") })
        }
        
        @Test("tryFilter(_:)")
        func test2() async throws {
            struct ZeroError: Error {}
            let _ = [1, 2, 3, 4, 5, 0, 6].publisher
                .tryFilter({
                    if $0 == 0 {
                        throw ZeroError()
                    } else {
                        return $0 % 2 == 0
                    }
                })
                .sink(receiveCompletion: { print("\($0)") },
                      receiveValue: { print("\($0)", terminator: " ") })
        }
        
        /// Calls a closure with each received element and publishes any returned optional that has a value.
        @Test("compactMap(_:)")
        func test3() async throws {
            let numbers = (0...5)
            let romanNumberDict: [Int: String] = [
                1: "I", 2: "II", 3: "III", 5: "V"
            ]
            let _ = numbers
                .publisher
                .compactMap({ romanNumberDict[$0] })
                .sink(receiveValue: { print("\($0)", terminator: " ")})
        }
        
        /// Calls an error-throwing closure with each received element and publishes any returned optional that has a value.
        @Test("tryCompactMap(_:)")
        func test4() async throws {
            struct ParseError: Error {}
            func romanNumeral(from: Int) throws -> String? {
                let romanNumberDict: [Int: String] = [
                    1: "I", 2: "II", 3: "III", 5: "V"
                ]
                guard from != 0 else { throw ParseError() }
                return romanNumberDict[from]
            }
            let numbers = [6, 5, 4, 3, 2, 1, 0]
            _ = numbers.publisher
                .tryCompactMap({ try romanNumeral(from: $0) })
                .sink(receiveCompletion: { print("\($0)" )},
                      receiveValue: { print("\($0)", terminator: " ")})
        }
        
        /// Publishes only elements that don't match the previous element.
        @Test("removeDuplicates()")
        func test5() async throws {
            let numbers = [0, 1, 2, 2, 2, 3, 4, 4, 5, 6, 6, 6, 7, 7, 7, 7,8, 8, 80]
            _ = numbers.publisher
                .removeDuplicates()
                .sink(receiveValue: { print("\($0)", terminator: " ") })
        }
        
        /// Publishes only elements that don't match the previous element, as evaluated by a provided closure.
        @Test("removeDuplicates(by:)")
        func test6() async throws {
            struct Point {
                let x: Int
                let y: Int
            }
            
            let points = [Point(x: 0, y: 0), Point(x: 0, y: 1),
                          Point(x: 1, y: 1), Point(x: 2, y: 1)]
            
            _ = points.publisher
                .removeDuplicates(by: { prev, current in
                    prev.x == current.x
                })
                .sink(receiveValue: { print("\($0)", terminator: " ") })
        }
        
        /// Publishes only elements that don't match the previous element, as evaluated by a provided error-throwing closure.
        @Test("tryRemoveDuplicates(by:)")
        func test7() async throws {
            struct BadValuesError: Error {}
            let numbers = [0, 0, 0, 0, 1, 2, 2, 3, 3, 3, 4, 4, 4, 4]
            _ = numbers.publisher
                .tryRemoveDuplicates { first, second -> Bool in
                    if (first == 4 && second == 4) {
                        throw BadValuesError()
                    }
                    return first == second
                }
                .sink(
                    receiveCompletion: { print ("\($0)") },
                    receiveValue: { print ("\($0)", terminator: " ") }
                )
        }
        
        /// Replaces an empty stream with the provided element.
        @Test("replaceEmpty(with:)")
        func test8() async throws {
            let numbers: [Double] = []
            _ = numbers.publisher
                .replaceEmpty(with: Double.nan)
                .sink(receiveValue: { print("\($0)", terminator: " ")})
        }
        
        /// Replaces any errors in the stream with the provided element.
        @Test("replaceError(with:)")
        func test9() async throws {
            struct MyError: Error {}
            let fail = Fail<String, MyError>(error: MyError())
            _ = fail
                .replaceError(with: "(replacement element)")
                .sink(receiveCompletion: { print("\($0)" )},
                      receiveValue: { print("\($0)", terminator: " ")})
        }
    }
    
    @Suite("Reducing elements")
    struct ReducingOperators {
        /// Collects all received elements, and emits a single array of the collection when the upstream publisher finishes.
        @Test("collect()")
        func test1() async throws {
            _ = (0..<20)
                .publisher
                .collect()
                .sink(receiveValue: { print("\($0)") })
        }
        
        /// Collects up to the specified number of elements, and then emits a single array of the collection
        @Test("collect(_:)")
        func test2() async throws {
            _ = (0..<10)
                .publisher
                .collect()
                .sink(receiveValue: { print("\($0)") })
            
            _ = (0..<10)
                .publisher
                .collect(5)
                .sink(receiveValue: { print("\($0)") })
        }
        
        /// Collects elements by a given time-grouping strategy, and emits a single array of the collection.
        @Test("collect(_:options:)")
        func test3() async throws {
            let sub = Timer.publish(every: 1, on: .main, in: .default)
                .autoconnect()
                .collect(.byTime(RunLoop.main, .seconds(5)))
                .sink(receiveValue: { print("\($0)", terminator: "\n\n") })
            
            try await Task.sleep(for: .seconds(6))
            
            sub.cancel()
        }
        
        /// Ignores all upstream elements, but passes along the upstream publisher's completion state (finished or failed).
        @Test("ignoreOutput()")
        func test4() async throws {
            struct NoZeroValuesAllowedError: Error {}
            let numbers = [1, 2, 3, 4, 5, 6, 7, 0, 8, 9]
            let sub = numbers.publisher
                .tryFilter({ anInt in
                    guard anInt != 0 else { throw NoZeroValuesAllowedError() }
                    return anInt < 20
                })
                // .ignoreOutput()
                .sink(receiveCompletion: { print("completion: \($0)") },
                      receiveValue: { print("value \($0)") })
            sub.cancel()
        }
        
        /// Applies a closure that collects each
        @Test("reduce(_:_:)")
        func test5() async throws {
            let _ = (0...10).publisher
                .reduce(0, +)
                .sink(receiveValue: { print("\($0)") })
        }
        
        /// Applies an error-throwing closure that collects each element of a stream and publishes a final result upon completion.
        @Test("tryReduce(_:_:)")
        func test6() async throws {
            struct DivisionByZeroError: Error {}
            func myDivide(_ dividend: Double, _ divisor: Double) throws -> Double {
                guard divisor != 0 else { throw DivisionByZeroError() }
                return dividend / divisor
            }
            
            
            let numbers: [Double] = [5, 4, 3, 2, 1, 0]
            let _ = numbers.publisher
                .tryReduce(numbers.first!, { accum, next in try myDivide(accum, next) })
                .catch({ _ in Just(Double.nan) })
                .sink { print("\($0)") }
        }
    }
    
    @Suite("Mathematical elements")
    struct MathematicalOperators {
        /// Publishes the number of elements received from the upstream publisher.
        @Test("count()")
        func test1() async throws {
            _ = (0...10)
                .publisher
                .count()
                .sink(receiveValue: { print("\($0)") })
        }
        
        /// Publishes the maximum value received from the upstream publisher, after it finishes.
        @Test("max()")
        func test2() async throws {
            _ = [0, 10, 5]
                .publisher
                .max()
                .sink(receiveValue: { print("\($0)") })
        }
        
        /// Publishes the maximum value received from the upstream publisher, using the provided ordering closure.
        @Test("max(by:)")
        func test3() async throws {
            _ = [5, 9, 3, 2, 8]
                .publisher
                .max(by: { cur, nxt in
                    cur < nxt
                })
                .sink(receiveValue: { print("\($0)") })
        }
        
        /// Publishes the maximum value received from the upstream publisher, using the provided error-throwing closure to order the items.
        @Test("tryMax(by:)")
        func test4() async throws {
            struct IllegalValueError: Error {}
            
            let numbers: [Int]  = [0, 10, 6, 13, 22, 22]
            _ = numbers.publisher
                .tryMax { first, second -> Bool in
                    if (first % 2 != 0) {
                        throw IllegalValueError()
                    }
                    return first > second
                }
                .sink(
                    receiveCompletion: { print ("completion: \($0)") },
                    receiveValue: { print ("value: \($0)") }
                )
        }
        
        /// Publishes the minimum value received from the upstream publisher, after it finishes.
        @Test("min()")
        func test5() async throws {
            let numbers = [-1, 0, 10, 5]
            _ = numbers.publisher
                .min()
                .sink { print("\($0)") }
        }
        
        /// Publishes the minimum value received from the upstream publisher, after it finishes.
        @Test("min(by:)")
        func test6() async throws {
            enum Rank: Int {
                case ace = 1, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king
            }
            
            
            let cards: [Rank] = [.five, .queen, .ace, .eight, .king]
            _ = cards.publisher
                .min {
                    return  $0.rawValue < $1.rawValue
                }
                .sink { print("\($0)") }
        }
        
        /// Publishes the minimum value received from the upstream publisher, using the provided error-throwing closure to order the items.
        @Test("tryMin(by:)")
        func test7() async throws {
            struct IllegalValueError: Error {}
            
            let numbers: [Int]  = [0, 10, 6, 13, 22, 22]
            _ = numbers.publisher
                .tryMin { first, second -> Bool in
                    if (first % 2 != 0) {
                        throw IllegalValueError()
                    }
                    return first < second
                }
                .sink(
                    receiveCompletion: { print ("completion: \($0)") },
                    receiveValue: { print ("value: \($0)") }
                )
        }
    }
    
    @Suite("Matching elements")
    struct MatchingCriteriaOperators {
        /// Publishes a Boolean value upon receiving an element equal to the argument.
        @Test("contains(_:)")
        func test1() async throws {
            _ = [-1, 5, 10, 5]
                .publisher
                .contains(5)
                .sink(receiveValue: { print("\($0)") })
        }
        
        /// Publishes a Boolean value upon receiving an element that satisfies the predicate closure.
        @Test("contains(where:)")
        func test2() async throws {
            _ = [-1, 0, 10, 5]
                .publisher
                .contains(where: { $0 > 4 })
                .sink(receiveValue:  { print("\($0)") })
        }
        
        /// Publishes a Boolean value upon receiving an element that satisfies the throwing predicate closure.
        @Test("tryContains(where:)")
        func test3() async throws {
            struct IllegalValueError: Error {}
            
            let numbers = [3, 2, 10, 5, 0, 9]
            _ = numbers.publisher
                .tryContains {
                    if ($0 % 2 != 0) {
                        throw IllegalValueError()
                    }
                    return $0 < 10
                }
                .sink(
                    receiveCompletion: { print ("completion: \($0)") },
                    receiveValue: { print ("value: \($0)") }
                )
        }
        
        /// Publishes a single Boolean value that indicates whether all received elements pass a given predicate.
        @Test("allStisfy(_:)")
        func test4() async throws {
            let targetRange = (-1...100)
            let numbers = [-1, 0, 10, 5]
            _ = numbers.publisher
                .allSatisfy({ targetRange.contains($0) })
                .sink(receiveValue: { print("\($0)") })
        }
        
        /// Publishes a single Boolean value that indicates whether all received elements pass a given error-throwing predicate.
        @Test("tryAllSatisfy(_:)")
        func test5() async throws {
            struct IllegalValueError: Error {}
            let targetRange = (-1...100)
            let numbers = [-1, 10, 5, 0]
            
            _ = numbers.publisher
                .tryAllSatisfy { anInt in
                    guard anInt != 0 else { throw IllegalValueError() }
                    return targetRange.contains(anInt)
                }
                .sink(
                    receiveCompletion: { print ("completion: \($0)") },
                    receiveValue: { print ("value: \($0)") }
                )
        }
    }
    
    @Suite("Sequencing elements")
    struct SequenceOperators {
        /// Ignores elements from the upstream publisher until it receives an element from a second publisher.
        @Test("drop(untilOutputFrom:)")
        func test1() async throws {
            let upstream = PassthroughSubject<Int, Never>()
            let second = PassthroughSubject<String, Never>()
            
            let cancellable = upstream
                .drop(untilOutputFrom: second)
                .sink(receiveValue: { print("\($0)", terminator: " ") })
            
            upstream.send(1)
            upstream.send(2)
            second.send("A")
            upstream.send(3)
            upstream.send(4)
            
            cancellable.cancel()
        }
        
        /// Omits the specified number of elements before republishing subsequent elements.
        @Test("dropFirst(_:)")
        func test2() async throws {
            _ = (0...10)
                .publisher
                .dropFirst(5)
                .sink(receiveValue: { print("\($0)", terminator: " ") })
        }
        
        /// Omits elements from the upstream publisher until a given closure returns false, before republishing all remainig elements.
        @Test("drop(while:)")
        func test3() async throws {
            _ = [-62, -1, 0, 10, 0, 22, 41, -1, 5]
                .publisher
                .drop(while: { $0 <= 0 })
                .sink(receiveValue: { print("\($0)", terminator: " ") })
        }
        
        /// Omits elements from the upstream publisher until an error-throwing closure returns false, before republishing all remaining elements.
        @Test("tryDrop(while:)")
        func test4() async throws {
            struct RangeError: Error {}
            let numbers = [1, 2, 3, 4, 5, 6, -1, 7, 8, 9, 10]
            let range: CountableClosedRange<Int> = (1...100)
            _ = numbers.publisher
                .tryDrop {
                    guard $0 != 0 else { throw RangeError() }
                    return range.contains($0)
                }
                .sink(
                    receiveCompletion: { print ("completion: \($0)") },
                    receiveValue: { print ("value: \($0)") }
                )
        }
        
        /// Appends a publisher's output with the specified elements.
        @Test("append(_:)")
        func test5() async throws {
            _ = (0...10)
                .publisher
                .append(0, 1, 255)
                .sink(receiveValue: { print("\($0)", terminator: " ") })
        }
        
        /// Appends a publisher's output with the specified sequence.
        @Test("append(_:)")
        func test6() async throws {
            let groundTransport = ["car", "bus", "truck", "subway", "bicycle"]
            let airTransport = ["parasil", "jet", "helicopter", "rocket"]
            _ = groundTransport
                .publisher
                .append(airTransport.publisher)
                .sink(receiveValue: { print("\($0)", terminator: " ")})
        }
        
        /// Appends the output of this publisher with the elements emitted by the given publisher.
        @Test("append(_:)")
        func test7() async throws {
            let numbers = (0...10)
            let other = (25...35)
            _ = numbers.publisher
                .append(other.publisher)
                .sink(receiveValue: { print("\($0)", terminator: " ") })
        }
        
        /// Prefixes a publisher's output with the specified values.
        @Test("prepand(_:)")
        func test8() async throws {
            _ = (0...10)
                .publisher
                .prepend(0, 1, 255)
                .sink(receiveValue: { print("\($0)", terminator: " ") })
        }
        
        /// Prefixes a publisher's output with the specified sequence.
        @Test("prepand(_:)")
        func test9() async throws {
            let sequence = [0, 1, 255]
            
            _ = (0...10)
                .publisher
                .prepend(sequence)
                .sink(receiveValue: { print("\($0)", terminator: " ") })
        }
        
        /// Prefixes the output of this publisher with the elements emitted by the given publisher.
        @Test("prepand(_:)")
        func test10() async throws {
            let sequence = [0, 1, 255]
            
            _ = (0...10)
                .publisher
                .prepend(sequence.publisher)
                .sink(receiveValue: { print("\($0)", terminator: " ") })
        }
        
        /// Republishes elements up to the specified maximum count.
        @Test("prefix(_:)")
        func test11() async throws {
            _ = (0...10)
                .publisher
                .prefix(2)
                .sink(receiveValue: { print("\($0)", terminator: " ") })
        }
        
        /// Republishes elements while a predicate closure indicates publishing should continue
        @Test("prefix(while:)")
        func test12() async throws {
            _ = (0...10)
                .publisher
                .prefix(while: { $0 < 5 })
                .sink(receiveValue: { print("\($0)", terminator: " ") })
        }
        
        /// Republishes elements while an error-throwing predicate closure indicates publishing should continue.
        @Test("tryPrefix(while:)")
        func test13() async throws {
            struct OutOfRangeError: Error {}
            
            
            let numbers = (0...10).reversed()
            _ = numbers.publisher
                .tryPrefix {
                    guard $0 != 0 else {throw OutOfRangeError()}
                    return $0 <= numbers.max()!
                }
                .sink(
                    receiveCompletion: { print ("completion: \($0)", terminator: " ") },
                    receiveValue: { print ("\($0)", terminator: " ") }
                )
        }
        
        /// Republishes elements until another publisher emits an element.
        @Test("prefix(untilOutputFrom:)")
        func test14() async throws {
            let numSub = PassthroughSubject<Int, Never>()
            let otherSub = PassthroughSubject<Int, Never>()
            
            let cancellable = numSub
                .prefix(untilOutputFrom: otherSub)
                .sink(receiveValue: { print("\($0)", terminator: " ") })
            
            numSub.send(0)
            numSub.send(1)
            numSub.send(2)
            
            otherSub.send(99)
            
            numSub.send(224)
            // Prints: 0 1 2
            
            cancellable.cancel()
        }
    }
    
    @Suite("Selecting elements")
    struct SelectingOperators {
        /// Publishes the first element of a stream, then finishes.
        @Test("first()")
        func test1() async throws {
            _ = (-10...10)
                .publisher
                .first()
                .sink(receiveValue: { print("\($0)") })
        }
        
        /// Publishes the first element of a stream to satisfy a predicate closure, then finishes normally.
        @Test("first(where:)")
        func test2() async throws {
            _ = (-10...10)
                .publisher
                .first(where: { $0 > 0 })
                .sink(receiveValue: { print("\($0)") })
        }
        
        /// Publishes the first element of a stream to satisfy a throwing predicate closure, then finishes normally.
        @Test("tryFirst(where:)")
        func test3() async throws {
            _ = (-1...50)
                .publisher
                .tryFirst(where: {
                    guard $0 < 99 else { throw POSIXError(.EAUTH) }
                    return true
                })
                .sink(receiveCompletion: { print("completion: \($0)", terminator: " ")},
                      receiveValue: { print("\($0)", terminator: " ") })
        }
        
        /// Publishes the last element of a stream, after the stream finishes.
        @Test("last()")
        func test4() async throws {
            _ = (-10...10)
                .publisher
                .last()
                .sink(receiveValue: { print("\($0)") })
        }
        
        /// Publishes the last element of a stream that satisfies a predicate closure, after upstream finishes.
        @Test("last(where:)")
        func test5() async throws {
            _ = (-10...10)
                .publisher
                .last(where: { $0 < 6 })
                .sink(receiveValue: { print("\($0)") })
        }
        
        /// Publishes the last element of a stream that satisfies an error-throwing predicate closure, after the stream finishes.
        @Test("tryLast(where:)")
        func test6() async throws {
            _ = [-62, 1, 5, 10, 9, 22, 0, 51, 3, 2, -45]
                .publisher
                .tryLast(where: {
                    guard $0 != 0 else { throw POSIXError(.EACCES) }
                    return true
                })
                .sink(receiveCompletion: { print("completion: \($0)", terminator: " ") },
                      receiveValue: { print("\($0)", terminator: " ") })
        }
        
        /// Publishes a specific element, indicated by its index in the sequence of published elements.
        @Test("output(at:)")
        func test7() async throws {
            _ = (1...10)
                .publisher
                .output(at: 5)
                .sink(receiveValue: { print("\($0)") })
        }
        
        /// Publishes elements specified by their range in the sequence of published elements.
        @Test("output(in:)")
        func test8() async throws {
            _ = [1, 1, 2, 2, 2, 3, 3, 4, 5, 6]
                .publisher.output(in: (3...5))
                .sink(receiveValue: { print("\($0)", terminator: " ") })
        }
    }
    
    @Suite("Republishing the latest elements")
    struct RepublishingLatestOperators {
        /// Subscribes to an additional publisher and invokes a closure upon receiving output from either publisher.
        @Test("combineLatest(_:_:)")
        func test1() async throws {
            let pub1 = PassthroughSubject<Int, Never>()
            let pub2 = PassthroughSubject<Int, Never>()
            
            let cancellable = pub1
                .combineLatest(pub2, { (first, second) in
                    return "pub1 = \(first)\t pub2 = \(second)\t result = \(first * second)"
                })
                .sink(receiveValue: { print($0) })
            
            pub1.send(1)
            pub1.send(2)
            pub2.send(2)
            pub1.send(9)
            pub1.send(3)
            pub2.send(12)
            pub1.send(13)
            
            cancellable.cancel()
        }
        
        /// Subscribes to an additional publisher and publishes a tuple upon receiving output from either publisher.
        @Test("combineLatest(_:)")
        func test2() async throws {
            let pub1 = PassthroughSubject<Int, Never>()
            let pub2 = PassthroughSubject<Int, Never>()
            
            let cancellable = pub1
                .combineLatest(pub2)
                .sink(receiveValue: { print("result = \($0)") })
            
            pub1.send(1)
            pub1.send(2)
            pub2.send(2)
            pub1.send(3)
            pub1.send(45)
            pub2.send(22)
            
            cancellable.cancel()
        }
        
        /// Subscribes to two additional publishers and invokes a closure upon receiving output from any of the publishers.
        @Test("combineLatest(_:_:_)")
        func test3() async throws {
            let pub1 = PassthroughSubject<Int, Never>()
            let pub2 = PassthroughSubject<Int, Never>()
            let pub3 = PassthroughSubject<Int, Never>()
            
            let cancellable = pub1
                .combineLatest(pub2, pub3, { (first, second, third) in
                    return "pub1 = \(first)\t pub2 = \(second)\t pub3 = \(third)\t result = \(first * second * third)"
                })
                .sink(receiveValue: { print($0) })
            
            pub1.send(1)
            pub1.send(2)
            
            pub2.send(2)
            pub3.send(10)
            
            pub1.send(9)
            pub3.send(4)
            pub2.send(12)
            
            cancellable.cancel()
        }
    }
    
    @Suite("Republishing as the interleaved elements")
    struct RepublishingInterleavingOperators {
        /// Combines elements from this publisher with those from another publisher of the same type, delivering an interleaved sequence of elements.
        @Test("merge(with:)")
        func test1() async throws {
            let pub1 = PassthroughSubject<Int, Never>()
            let pub2 = PassthroughSubject<Int, Never>()
            
            let can = pub1
                .merge(with: pub2)
                .sink(receiveValue: { print($0, terminator: " ") })
            
            pub1.send(1)
            pub2.send(2)
            pub1.send(3)
            pub2.send(4)
            pub2.send(5)
            pub1.send(6)
            pub2.send(7)
            
            can.cancel()
        }
    }
    
    @Suite("Republihsing the oldest elements")
    struct RepublishingOldestOperators {
        /// Combines elements from another publisher and deliver pairs of elements as tuples.
        @Test("zip(_:)")
        func test1() async throws {
            let pub1 = PassthroughSubject<Int, Never>()
            let pub2 = PassthroughSubject<Int, Never>()
            
            let cancellable = pub1
                .zip(pub2)
                .sink(receiveValue: { print($0) })
            
            pub1.send(1)
            pub1.send(2)
            pub1.send(3)
            
            pub2.send(-1)
            pub2.send(-2)
            pub2.send(-3)
            
            pub1.send(4)
            pub1.send(5)
            pub2.send(-4)
            
            cancellable.cancel()
        }
    }
    
    @Suite("Republishing elements by subscribing to new publishers")
    struct RepublishingNewPublisherOperators {
        /// Transforms all elements from an upstream publisher into a new publisher up to a maximum number of publishers you specify.
        @Test("flatMap(maxPublishers:_:)")
        func test1() async throws {
            _ = Just(0)
                .flatMap({ num in
                    Just("\(num) - \(num)")
                })
                .sink(receiveValue: { print($0) })
        }
        
        /// Republishes elements sent by the most recently received publisher.
        @Test("switchToLatest()")
        func test2() async throws {
            let subject = PassthroughSubject<Int, Never>()
            let cancellable = subject
                .setFailureType(to: URLError.self)
                .map() { index -> URLSession.DataTaskPublisher in
                    let url = URL(string: "https://example.org/get?index=\(index)")!
                    return URLSession.shared.dataTaskPublisher(for: url)
                }
                .switchToLatest()
                .sink(receiveCompletion: { print("Complete: \($0)") },
                      receiveValue: { (data, response) in
                    guard let url = response.url else { print("Bad response."); return }
                    print("URL: \(url)")
                })
            
            
            for index in 1...5 {
                try await Task.sleep(for: .seconds(TimeInterval(index/10)))
                subject.send(index)
            }
            
            
            // Prints "URL: https://example.org/get?index=5"
        }
    }
    
    @Suite("Handling errors")
    struct HandlingErrorOperators {
        /// Raises a fatal error when its upstream publisher fails, and otherwise republishes all received input.
        @Test("assertNoFailure(_:file:line:)")
        func test1() async throws {
            enum SubjectError: Error {
                case genericSubjectError
            }
            
            let subject = CurrentValueSubject<String, Error>("initial value")
            let cancellable = subject
                .assertNoFailure()
                .sink(receiveCompletion: { print($0) }, receiveValue: { print($0) })
            
            subject.send("second value")
            subject.send(completion: .failure(SubjectError.genericSubjectError))
            cancellable.cancel()
        }
        
        /// Handles errors from an upstream publisher by replacing it with another publisher.
        @Test("catch(_:)")
        func test2() async throws {
            struct SimpleError: Error {}
            _ = [5, 4, 3, 2, 1, 0, 9, 8, 7, 6]
                .publisher
                .tryLast(where: {
                    guard $0 != 0 else { throw SimpleError() }
                    return true
                })
                .catch({ error in
                    Just(-1)
                })
                .sink(receiveValue: { print($0) })
        }
        
        /// Handles errors from an upstream publisher by either replacing it with another publisher or throwing a new error.
        @Test("tryCatch(_:)")
        func test3() async throws {
            struct SimpleError: Error {}
            _ = [5, 4, 3, 2, 1, -1, 7, 8, 9, 10]
                .publisher
                .tryMap({ v in
                    if v > 0 {
                        return v
                    } else {
                        throw SimpleError()
                    }
                })
                .tryCatch({ error in
                    Just(0)
                })
                .sink(receiveCompletion: { print($0) },
                      receiveValue: { print($0) })
        }
        
        /// Attempts to recreate a failed subscription with the upstream publisher up to the number of times you specify.
        @Test("retry(_:)")
        func test4() async throws {
            struct WebsiteData: Codable {
                var rawHTML: String
            }
            
            let myURL = URL(string: "https://www.example.com")
            
            let cancellable = URLSession.shared.dataTaskPublisher(for: myURL!)
                .retry(3)
                .map({ page -> WebsiteData in
                    return WebsiteData(rawHTML: String(decoding: page.data, as: UTF8.self))
                })
                .catch({ error in
                    Just(WebsiteData(rawHTML: "<HTML>Unable to load page - timed out.</HTML>"))
                })
                .sink(receiveCompletion: { print("completion: \($0)" )},
                      receiveValue: { print("value: \($0)") })
            
            try await Task.sleep(for: .seconds(6))
            cancellable.cancel()
        }
    }
}

