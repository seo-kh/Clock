//
//  Stopwatch.swift
//  Stopwatch
//
//  Created by james seo on 1/8/26.
//

import Foundation
import Observation

protocol StopwatchControllerFactory {
    func lapRepository() -> LapRepository
    func flagRepository() -> FlagRepository
    func timerSource() -> TimerSource
    func activationSource() -> AppActivationSource
}

final class ProductionFactory: StopwatchControllerFactory {
    func lapRepository() -> any LapRepository {
        SDLapRepository()
    }
    
    func flagRepository() -> any FlagRepository {
        UserDefaultsFlagRepository()
    }
    
    func timerSource() -> any TimerSource {
        CombineTimerSource(timeInterval: 0.003)
    }
    
    func activationSource() -> any AppActivationSource {
        NotificationAppActivationSource()
    }
}

protocol StopwatchControllerDelegate: AnyObject {
    func didUpdate(_ date: Result<Date, Error>)
    func didStop(_ error: Error?)
    func didAddLap(_ error: Error?)
    func didResetLap(_ error: Error?)
    func didRead(_ laps: Result<[Lap], Error>)
    func didChange(_ activation: Result<Bool, Error>)
    func getStartFlag(_ flag: Result<Bool, Error>)
    func setStartFlag(_ error: Error?)
}

final class StopwatchController {
    /// 타이머
    private let timerSource: TimerSource
    /// 앱 현재 활성화 여부
    private let activationSource: AppActivationSource
    /// Lap 데이터 영구 저장소
    private let lapRepository: LapRepository
    /// 자동시작 데이터 영구 저장소
    private let flagRepository: FlagRepository
    
    private weak var delegate: StopwatchControllerDelegate?

    init(lapRepository: LapRepository,
         flagRepository: FlagRepository,
         timerSource: TimerSource,
         activationSource: AppActivationSource) {
        self.lapRepository = lapRepository
        self.flagRepository = flagRepository
        self.timerSource = timerSource
        self.activationSource = activationSource
    }
    
    convenience init(factory: StopwatchControllerFactory) {
        self.init(lapRepository: factory.lapRepository(),
                  flagRepository: factory.flagRepository(),
                  timerSource: factory.timerSource(),
                  activationSource: factory.activationSource())
    }
    
    func configure(delegate: StopwatchControllerDelegate?) {
        self.delegate = delegate
        
        self.lapRepository.read(completion: { [weak self] result in
            self?.delegate?.didRead(result)
        })
        
        self.activationSource.start(onUpdate: { [weak self] result in
            self?.delegate?.didChange(result)
        })
        
        self.flagRepository.get(completion: { [weak self] result in
            self?.delegate?.getStartFlag(result)
        })
    }
    
    func start() {
        self.timerSource.start(onUpdate: { [weak self] result in
            self?.delegate?.didUpdate(result)
        })
        
        self.flagRepository.set(true, completion: { [weak self] result in
            self?.delegate?.setStartFlag(result)
        })
    }
    
    func stop() {
        self.timerSource.stop(onCompletion: { [weak self] error in
            self?.delegate?.didStop(error)
        })
        
        self.flagRepository.set(false, completion: { [weak self] result in
            self?.delegate?.setStartFlag(result)
        })
    }
    
    func lap(_ lap: Lap) {
        self.lapRepository.create(lap, completion: { [weak self] error in
            self?.delegate?.didAddLap(error)
        })
    }
    
    func reset() {
        self.lapRepository.delete(completion: { [weak self] error in
            self?.delegate?.didResetLap(error)
        })
        
        self.flagRepository.set(false, completion: { [weak self] result in
            self?.delegate?.setStartFlag(result)
        })
    }
}

@Observable
final class Stopwatch {
    private(set) var laps: [Lap] = []
    private(set) var components: [ActionComponent] = []
    private(set) var isActive: Bool = false
    private(set) var watchMode: WatchMode!
    
    private let controller: StopwatchController
    
    init() {
        self.controller = StopwatchController(factory: ProductionFactory())
        self.controller.configure(delegate: self)
        self.watchMode = WatchMode(isActive: false, change: self.changeWatchMode)
    }
}

extension Stopwatch: StopwatchControllerDelegate {
    func didUpdate(_ date: Result<Date, any Error>) {
        guard !laps.isEmpty else { return }
        
        switch date {
        case .success(let _date):
            self.laps[0].progress = _date
        case .failure(let error):
            print(error)
        }
    }
    
    func didStop(_ error: (any Error)?) {
        if let error {
            print(error)
        }
    }
    
    func didAddLap(_ error: (any Error)?) {
        if let error {
            print(error)
        }
    }
    
    func didResetLap(_ error: (any Error)?) {
        if let error {
            print(error)
        }
    }
    
    func didChange(_ activation: Result<Bool, any Error>) {
        switch activation {
        case .success(let isActive):
            self.isActive = isActive
        case .failure(let error):
            print(error)
        }
    }
    
    func didRead(_ laps: Result<[Lap], any Error>) {
        switch laps {
        case .success(let _laps):
            self.laps = _laps
        case .failure(let error):
            print(error)
        }
    }
    
    func getStartFlag(_ flag: Result<Bool, any Error>) {
        switch flag {
        case .success(let _flag):
            if _flag {
                self.start()
                self.setStartButtons()
            } else {
                self.setResetButtons()
            }
        case .failure(let error):
            print(error)
        }
    }
    
    func setStartFlag(_ error: (any Error)?) {
        if let error {
            print(error)
        }
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
    }
    
    func stop() {
        stopTimer()
        setStopButtons()
    }
    
    func reset() {
        resetLaps()
        setResetButtons()
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
        self.controller.start()
    }
    
    private func stopTimer() {
        self.controller.stop()
    }
}

/// Lap Control
extension Stopwatch {
    private func addLap() {
        let newLap: Lap = self.laps[0].next()
        self.controller.lap(newLap)
        self.laps.insert(newLap, at: 0)
    }
    
    private func resetLaps() {
        self.controller.reset()
        self.laps.removeAll()
    }
    
    private func configureLaps() {
        if laps.isEmpty {
            let now: Date = Date.now
            let newLap = Lap(number: 1, split: now, total: now, progress: now)
            
            self.controller.lap(newLap)
            self.laps.append(newLap)
        } else {
            laps[0].adjust()
        }
    }
}

private extension Stopwatch {
    func changeWatchMode() {
        self.watchMode.isActive.toggle()
    }
}
