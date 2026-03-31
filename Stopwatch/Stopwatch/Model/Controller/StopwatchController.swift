//
//  StopwatchController.swift
//  Stopwatch
//
//  Created by alphacircle on 3/31/26.
//

import Foundation

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
         activationSource: AppActivationSource,
         delegate: StopwatchControllerDelegate?) {
        self.lapRepository = lapRepository
        self.flagRepository = flagRepository
        self.timerSource = timerSource
        self.activationSource = activationSource
        self.delegate = delegate
    }
    
    convenience init(configuration: StopwatchControllerConfiguration, delegate: StopwatchControllerDelegate? = nil) {
        self.init(lapRepository: configuration.lapRepository(),
                  flagRepository: configuration.flagRepository(),
                  timerSource: configuration.timerSource(),
                  activationSource: configuration.activationSource(),
                  delegate: delegate)
    }
    
    func configure() {
        self.lapRepository.read(completion: { [weak self] result in
            switch result {
            case .success(let laps):
                self?.delegate?.didGet(laps)
            case .failure(let error):
                self?.delegate?.didCompleteWithError(error)
            }
        })
        
        self.activationSource.start(onUpdate: { [weak self] result in
            switch result {
            case .success(let isActive):
                self?.delegate?.didUpdate(isActive)
            case .failure(let error):
                self?.delegate?.didCompleteWithError(error)
            }
        })
        
        self.flagRepository.get(completion: { [weak self] result in
            switch result {
            case .success(let flag):
                self?.delegate?.didGet(flag)
            case .failure(let error):
                self?.delegate?.didCompleteWithError(error)
            }
        })
    }
    
    func start(in laps: inout [Lap]) {
        // configure
        if laps.isEmpty {
            let now: Date = Date.now
            let newLap = Lap(number: 1, split: now, total: now, progress: now)
            
            self.lapRepository.create(newLap, completion: { [weak self] error in
                if let error {
                    self?.delegate?.didCompleteWithError(error)
                }
            })
            
            laps.append(newLap)
        } else {
            laps[0].adjust()
        }
        
        // start
        self.timerSource.start(onUpdate: { [weak self] result in
            switch result {
            case .success(let date):
                self?.delegate?.didUpdate(date)
            case .failure(let error):
                self?.delegate?.didCompleteWithError(error)
            }
        })
        
        self.flagRepository.set(true, completion: { [weak self] error in
            if let error {
                self?.delegate?.didCompleteWithError(error)
            }
        })
    }
    
    func start() {
        self.timerSource.start(onUpdate: { [weak self] result in
            switch result {
            case .success(let date):
                self?.delegate?.didUpdate(date)
            case .failure(let error):
                self?.delegate?.didCompleteWithError(error)
            }
        })
        
        self.flagRepository.set(true, completion: { [weak self] error in
            if let error {
                self?.delegate?.didCompleteWithError(error)
            }
        })
    }
    
    func stop() {
        self.timerSource.stop(onCompletion: { [weak self] error in
            if let error {
                self?.delegate?.didCompleteWithError(error)
            }
        })
        
        self.flagRepository.set(false, completion: { [weak self] error in
            if let error {
                self?.delegate?.didCompleteWithError(error)
            }
        })
    }
    
    func lap(in laps: inout [Lap]) {
        guard let firstLap: Lap = laps.first else { return }
        
        let newLap: Lap = firstLap.next()
        
        self.lapRepository.create(newLap, completion: { [weak self] error in
            if let error {
                self?.delegate?.didCompleteWithError(error)
            }
        })
        
        laps.insert(newLap, at: 0)
    }
    
    func lap(_ lap: Lap) {
        self.lapRepository.create(lap, completion: { [weak self] error in
            if let error {
                self?.delegate?.didCompleteWithError(error)
            }
        })
    }
    
    func reset() {
        self.lapRepository.delete(completion: { [weak self] error in
            if let error {
                self?.delegate?.didCompleteWithError(error)
            }
        })
        
        self.flagRepository.set(false, completion: { [weak self] error in
            if let error {
                self?.delegate?.didCompleteWithError(error)
            }
        })
    }
}
