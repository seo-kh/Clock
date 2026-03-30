//
//  Stopwatch.swift
//  Stopwatch
//
//  Created by james seo on 1/8/26.
//

import Foundation
import Observation

@Observable
final class Stopwatch {
    private(set) var laps: [Lap] = []
    private(set) var components: [ActionComponent] = []
    private(set) var isActive: Bool = false
    private(set) var watchMode: WatchMode!
    
    /// 타이머
    private let timerSource: TimerSource
    /// 앱 현재 활성화 여부
    private let activationSource: AppActivationSource
    /// Lap 데이터 영구 저장소
    private let lapRepository: LapRepository
    /// 자동시작 데이터 영구 저장소
    private let flagRepository: FlagRepository

    init(lapRepository: LapRepository,
         flagRepository: FlagRepository,
         timerSource: TimerSource,
         activationSource: AppActivationSource) {
        self.lapRepository = lapRepository
        self.flagRepository = flagRepository
        self.timerSource = timerSource
        self.activationSource = activationSource
        self.watchMode = WatchMode(isActive: false, change: self.changeWatchMode)
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
        
        if watchMode.isActive {
            changeWatchMode()
        }
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
        self.timerSource.start(onUpdate: { [weak self] result in
            switch result {
            case .success(let date):
                self?.laps[0].progress = date
            case .failure(let error):
                print(error)
            }
        })
    }
    
    private func stopTimer() {
        self.timerSource.stop(onCompletion: { error in
            if let error { print(error) }
        })
    }
}

/// Lap Control
extension Stopwatch {
    private func addLap() {
        let newLap: Lap = self.laps[0].next()
        self.laps.insert(newLap, at: 0)
        self.lapRepository.create(newLap, completion: { error in
            if let error { print(error) }
        })
    }
    
    private func resetLaps() {
        self.laps.removeAll()
        self.lapRepository.delete { error in
            if let error { print(error) }
        }
    }
    
    private func configureLaps() {
        if laps.isEmpty {
            let now: Date = Date.now
            let newLap = Lap(number: 1, split: now, total: now, progress: now)
            laps.append(newLap)
            self.lapRepository.create(newLap, completion: { error in
                if let error { print(error) }
            })
        } else {
            laps[0].adjust()
        }
    }
    
    /// id를 기준으로 역방향으로 정렬해서 Lap 데이터 가져오기
    private func readLaps() {
        self.lapRepository.read(completion: { [weak self] result in
            switch result {
            case .success(let laps):
                self?.laps = laps
            case .failure(let error):
                print(error)
            }
        })
    }
}

/// Focus Detection
private extension Stopwatch {
    func subsribeActiveNotification() {
        self.activationSource.start { [weak self] result in
            switch result {
            case .success(let isActive):
                self?.isActive = isActive
            case .failure(let error):
                print(error)
            }
        }
    }
}

private extension Stopwatch {
    func setRunning(_ value: Bool) {
        self.flagRepository.set(value, completion: { error in
            if let error { print(error) }
        })
    }
    
    func startWhenRunning() {
        self.flagRepository.get(completion: { [weak self] result in
            switch result {
            case .success(let flag):
                if flag {
                    self?.start()
                }
            case .failure(let error):
                print(error)
            }
        })
    }
}

private extension Stopwatch {
    func changeWatchMode() {
        self.watchMode.isActive.toggle()
    }
}
