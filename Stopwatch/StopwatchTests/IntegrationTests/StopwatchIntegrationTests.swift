//
//  StopwatchIntegrationTests.swift
//  StopwatchTests
//
//  Created by alphacircle on 3/10/26.
//

import Testing
@testable import Stopwatch

struct StopwatchIntegrationTests {
    @Suite("ServiceTests")
    struct StopwatchServiceTests {
        @MainActor
        @Suite("Service Boot Tests")
        struct ServiceBootTests {
            @Test("초기화 테스트, laps: [], flag: false, lifecycle: true")
            func test1() async throws {
                // Given
                let service = DIService.testBoot1()
                
                let loadCmd = LoadLapCommand(configureLaps: { result in
                    // Then
                    #expect(throws: Never.self) {
                        let laps = try result.get()
                        #expect(laps.isEmpty)
                    }
                })
                
                let flagCmd = LoadStartFlagCommand { result in
                    #expect(result == false)
                }
                
                let lifecycleCmd = UpdateLifecycleCommand { result in
                    #expect(result == true)
                }
                
                // When
                service.loadLap(command: loadCmd)
                service.loadStartFlag(command: flagCmd)
                service.updateLifecycle(command: lifecycleCmd)
            }
        }
        
        @MainActor
        @Suite("Service Lap Tests")
        struct ServiceLapTests {
            @Test("빈 laps면 lap() 무시")
            func test1() async throws {
                // Given
                let service = DIService.testLap1()
                let lapCmd = LapCommand(source: []) { lap in
                    // Then
                    #expect(lap == nil)
                }
                // When
                service.lap(command: lapCmd)
            }
            
            @Test("lap()이 성공하면, 새로운 lap 획득 및 persistance에서 lap update")
            func test2() async throws {
                // Given
                let lapPort = MockLapAdapter(laps: [])
                let service = DIService.testLap2(lapPort)
                let lapCmd = LapCommand(source: [Lap.empty]) { lap in
                    // Then
                    #expect(lap != nil)
                }
                // When
                #expect(lapPort.laps.isEmpty == true)
                service.lap(command: lapCmd)
                // Then
                #expect(lapPort.laps.isEmpty == false)
            }
        }
        
        @MainActor
        @Suite("Service Start Tests")
        struct ServiceStartTests {
            @Test("laps가 비었을때, 현재날짜 기준의 Lap을 생성")
            func test1() async throws {
                // Given
                let service = DIService.testStart1()
                let command = ConfigureLapCommand(laps: []) { result in
                    // Then
                    #expect(throws: Never.self) {
                        let laps = try result.get()
                        #expect(laps.isEmpty == false)
                    }
                }
                // When
                service.configureLaps(command: command)
            }
            
            @Test("laps가 안비었을때, 현재날짜 기준으로 Lap을 조정")
            func test2() async throws {
                // Given
                let _lap = Lap.old
                let service = DIService.testStart2()
                let command = ConfigureLapCommand(laps: [_lap]) { result in
                    // Then
                    #expect(throws: Never.self) {
                        let laps = try result.get()
                        let first = try #require(laps.first)
                        
                        #expect(_lap.progress - _lap.split == first.progress - first.split)
                        #expect(_lap.progress - _lap.total == first.progress - first.total)
                    }
                }
                // When
                service.configureLaps(command: command)
            }
            
            @Test("start시, start flag가 설정되었는지 테스트")
            func test3() async throws {
                // Given
                let flag = MockStartFlagAdapter(isActive: false)
                let service = DIService.testStart3(flag: flag)
                #expect(flag.isActive == false)
                // When
                let command = SetStartFlagCommand(flag: true)
                service.setFlag(command: command)
                // Then
                #expect(flag.isActive == true)
            }
        }
        
        @MainActor
        @Suite("Service Stop Tests")
        struct ServiceStopTests {
            @Test("Stop할때, flag가 false인지 확인테스트")
            func test1() async throws {
                // Given
                let flag = MockStartFlagAdapter(isActive: true)
                let service = DIService.testStop1(flag: flag)
                // When
                let command = SetStartFlagCommand(flag: false)
                service.setFlag(command: command)
                // Then
                #expect(flag.isActive == false)
            }
        }
    }
}
