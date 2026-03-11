//
//  StopwatchSystemTests.swift
//  StopwatchTests
//
//  Created by alphacircle on 3/10/26.
//

import Testing
@testable import Stopwatch

final class MockModeAdapter: LoadModePort {
    func load(callback: @escaping (WatchMode) -> Void) {
        let mode = WatchMode(isActive: true, change: {})
        callback(mode)
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



final class _Stopwatch: StopwatchBootControllerDelegate {
    private(set) var laps: [Lap] = []
    private(set) var components: [ActionComponent] = []
    private(set) var isActive: Bool = false
    private(set) var watchMode: WatchMode!
    
    private var bootController: StopwatchBootController
    
    init(bootController: StopwatchBootController) {
        self.bootController = bootController
        self.boot()
    }
    
    private func boot() {
        self.bootController.boot(target: self)
        self.components = .idle
    }
    
    func lap(_ target: Result<[Lap], any Error>) {
        switch target {
        case .success(let laps):
            self.laps = laps
        case .failure(let error):
            print(error)
        }
    }
    
    func lifecycle(_ target: Bool) {
        self.isActive = target
    }
    
    func mode(_ target: WatchMode) {
        self.watchMode = target
    }
}

struct StopwatchSystemTests {

    @Suite("System Boot Tests")
    struct SystemBootTests {
        @Test("시스템 초기화 테스트")
        func test1() async throws {
            // Given
            let mode = MockModeAdapter()
            let lap = MockLapAdapter()
            let lifecycle = MockLifecycleAdapter()
            let service = StopwatchBootService(loadModePort: mode, loadLapPort: lap, lifecyclePort: lifecycle)
            let bootController = StopwatchBootController(useCase: service)
            
            // When
            let watch = _Stopwatch(bootController: bootController)
            
            // Then
            // UserDefaults 초기화 및 시작
            // #expect(watch.loadModePort != nil)
            // watch mode 초기화
            #expect(watch.watchMode != nil)
            // Persistance 초기화
            // #expect(watch.loadLapPort != nil)
            // Laps 초기화
            #expect(!watch.laps.isEmpty)
            // isActive
            #expect(watch.isActive)
            // Buttons 초기화
            #expect(!watch.components.isEmpty)
            // Notifications 초기화
            // #expect(watch.lifecyclePort != nil)
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
