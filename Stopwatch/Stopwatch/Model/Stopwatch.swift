//
//  Stopwatch.swift
//  Stopwatch
//
//  Created by alphacircle on 1/8/26.
//

import Foundation
import Observation
import Combine
import Cocoa
import SwiftData

@Observable
final class Stopwatch {
    private(set) var laps: [Lap] = []
    private(set) var components: [ActionComponent] = []
    private(set) var isActive: Bool = false

    @ObservationIgnored
    private var timer = Timer.publish(every: 0.03, on: .current, in: .common)
    /// Timer 취소
    @ObservationIgnored
    private var cancellable: Cancellable? = nil
    /// Activation 수신자
    @ObservationIgnored
    private var cancellables: Set<AnyCancellable> = []
    /// Lap 데이터 영구 저장소
    @ObservationIgnored
    private var context: ModelContext? = nil
    
    @ObservationIgnored
    private var userDefaults: UserDefaults? = nil
    @ObservationIgnored
    private static let defaultKey: String = "isRunning"

    init(configuration: Configuration = .debug) {
        self.configure(configuration)
        self.readLaps()
        self.setResetButtons()
        self.subsribeActiveNotification()
        self.startWhenRunning()
    }
}

/// Button Actions: Feature + UI update
private extension Stopwatch {
    func lap() {
        addLap()
    }
    
    func start() {
        configureLaps()
        startTimer()
        setStartButtons()
        setRunning(true)
    }
    
    func stop() {
        stopTimer()
        setStopButtons()
        setRunning(false)
    }
    
    func reset() {
        resetLaps()
        setResetButtons()
        setRunning(false)
    }
}

/// Button Configure
extension Stopwatch {
    private func setResetButtons() {
        self.components = [
            ActionComponent(title: "Lap", action: nil, style: .ckDisable),
            ActionComponent(title: "Start", action: self.start, style: .ckGreen),
        ]
    }
    private func setStartButtons() {
        self.components = [
            ActionComponent(title: "Lap", action: self.lap, style: .ckGray),
            ActionComponent(title: "Stop", action: self.stop, style: .ckRed),
        ]
    }
    private func setStopButtons() {
        self.components = [
            ActionComponent(title: "Reset", action: self.reset, style: .ckGray),
            ActionComponent(title: "Start", action: self.start, style: .ckGreen),
        ]
    }
}

/// Timer Control
extension Stopwatch {
    private func startTimer() {
        cancellable = timer
            .autoconnect()
            .sink(receiveValue: { [weak self] date in
                self?.laps[0].progress = date
            })
    }
    
    private func stopTimer() {
        cancellable?.cancel()
        cancellable = nil
    }
}

/// Lap Control
extension Stopwatch {
    private func addLap() {
        let newLap: Lap = self.laps[0].next()
        self.laps.insert(newLap, at: 0)
        self.context?.insert(newLap)
    }
    
    private func resetLaps() {
        self.laps.removeAll()
        try? self.context?.delete(model: Lap.self)
    }
    
    private func configureLaps() {
        if laps.isEmpty {
            let now: Date = Date.now
            let newLap = Lap(number: 1, split: now, total: now, progress: now)
            laps.append(newLap)
            context?.insert(newLap)
        } else {
            laps[0].adjust()
        }
    }
    
    /// id를 기준으로 역방향으로 정렬해서 Lap 데이터 가져오기
    private func readLaps() {
        let descriptor = FetchDescriptor<Lap>(sortBy: [SortDescriptor(\.id, order: SortOrder.reverse)])
        self.laps = (try? context?.fetch(descriptor)) ?? []
    }
}

/// Focus Detection
private extension Stopwatch {
    func subsribeActiveNotification() {
        NotificationCenter.default
            .publisher(for: NSApplication.didBecomeActiveNotification)
            .sink(receiveValue: { [weak self] _ in
                self?.isActive = true
            })
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: NSApplication.didResignActiveNotification)
            .sink(receiveValue: { [weak self] _ in
                self?.isActive = false
            })
            .store(in: &cancellables)
    }
}

private extension Stopwatch {
    func setRunning(_ value: Bool) {
        self.userDefaults?.set(value, forKey: Self.defaultKey)
    }
    
    func startWhenRunning() {
        switch self.userDefaults?.bool(forKey: Self.defaultKey) {
        case .some(true): start()
        default: break
        }
    }
}

extension Stopwatch {
    enum Configuration {
        case debug
        case release
        case custom(ModelContext)
    }
    
    private func configure(_ configuration: Configuration) {
        switch configuration {
        case .debug:
            self.context = nil
            self.userDefaults = nil
        case .release:
            let container = try! ModelContainer(for: Lap.self)
            self.context = ModelContext(container)
            self.userDefaults = UserDefaults()
        case .custom(let modelContext):
            self.context = modelContext
            self.userDefaults = UserDefaults()
        }
    }
}
