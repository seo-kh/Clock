//
//  StopwatchSystemTests.swift
//  StopwatchTests
//
//  Created by alphacircle on 3/10/26.
//

import Testing
@testable import Stopwatch

final class MockModeAdapter: LoadModePort {
    func load() -> WatchMode {
        WatchMode(isActive: true, change: {})
    }
}

final class MockLapAdapter: LoadLapPort {
    func load(callback: @escaping (Result<[Lap], Error>) -> Void) {
        let laps: [Lap] = [Lap.empty]
        callback(.success(laps))
    }
}

final class MockLifecycleAdapter: ListenLifecyclePort {
    func listen(callback: @escaping (Bool) -> Void) {
        callback(true)
    }
}

final class _Stopwatch {
    private(set) var laps: [Lap] = []
    private(set) var components: [ActionComponent] = []
    private(set) var isActive: Bool = false
    private(set) var watchMode: WatchMode!
    
    private(set) var loadModePort: LoadModePort!
    private(set) var loadLapPort: LoadLapPort!
    private(set) var lifecyclePort: ListenLifecyclePort!
    
    init() {
        //
    }
    
    func boot() {
        let loadModePort = MockModeAdapter()
        self.loadModePort = loadModePort
        self.watchMode = loadModePort.load()
        
        let loadLapPort = MockLapAdapter()
        self.loadLapPort = loadLapPort
        self.loadLapPort.load(callback: {
            if case let .success(laps) = $0 {
                self.laps = laps
            }
        })
        
        self.components = .start
        self.lifecyclePort = MockLifecycleAdapter()
        self.lifecyclePort.listen { isActive in
            
        }
    }
}

struct StopwatchSystemTests {

    @Suite("System Boot Tests")
    struct SystemBootTests {
        @Test("시스템 초기화 테스트")
        func test1() async throws {
            // Given
            let watch = _Stopwatch()
            // When
            watch.boot()
            // Then
            // UserDefaults 초기화 및 시작
            #expect(watch.loadModePort != nil)
            // watch mode 초기화
            #expect(watch.watchMode != nil)
            // Persistance 초기화
            #expect(watch.loadLapPort != nil)
            // Laps 초기화
            #expect(!watch.laps.isEmpty)
            // Buttons 초기화
            #expect(!watch.components.isEmpty)
            // Notifications 초기화
            #expect(watch.lifecyclePort != nil)
        }
    }

    @Test("시스템 시작 테스트")
    func test2() async throws {
        
    }
    
    @Test("시스템 중단 테스트")
    func test3() async throws {
        
    }
    
    @Test("시스템 취소 테스트")
    func test4() async throws {
        
    }
    
    @Test("시스템 취소 테스트")
    func test5() async throws {
        
    }
}
