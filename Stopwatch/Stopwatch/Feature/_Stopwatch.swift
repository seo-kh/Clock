//
//  _Stopwatch.swift
//  Stopwatch
//
//  Created by alphacircle on 3/11/26.
//

import Foundation
import Observation

// Stopwatch Module
@Observable
final class _Stopwatch {
    private(set) var laps: [Lap] = []
    private(set) var components: ActionComponents = .idle
    private(set) var display: DisplayStyle = DisplayStyle.laplist
    func setDisplay(_ display: DisplayStyle) {
        self.display = display
    }
    
    private var bootController: BootController?
    private var lapController: LapController?
    private var startController: StartController?
    private var stopController: StopController?
    private var resetController: ResetController?
    
    init(bootController: BootController?,
         lapController: LapController?,
         startController: StartController?,
         stopController: StopController?,
         resetController: ResetController?
    ) {
        self.bootController = bootController
        self.lapController = lapController
        self.startController = startController
        self.stopController = stopController
        self.resetController = resetController
        self.boot()
    }
    
    convenience init(configuration: StopwatchConfig) {
        self.init(bootController: configuration.bootController,
                  lapController: configuration.lapController,
                  startController: configuration.startController,
                  stopController: configuration.stopController,
                  resetController: configuration.resetController)
    }
    
    private func boot() {
        self.bootController?.loadLaps { [weak self] result in
            self?.didLoadLaps(result)
        }
        
        self.bootController?.loadStartFlag { [weak self] result in
            self?.didChangeStartFlag(result)
        }
        
        self.bootController?.updateLifecycle { [weak self] result in
            self?.didChangeLifecycle(result)
        }
        
        self.setResetButtons()
    }
    
    func lap() {
        self.lapController?.lap(at: laps) { [weak self] result in
            if let _result = result {
                self?.didAddLap(_result)
            }
        }
    }
    
    func start() {
        self.startController?.configureLaps(laps) { [weak self] result in
            self?.didLoadLaps(result)
        }
        self.startController?.startTimer { [weak self] result in
            self?.didChangeProgress(result)
        }
        
        self.startController?.enableStartFlag()
        
        // state
        self.setStartButtons()
    }
    
    func stop() {
        self.stopController?.stopTimer()
        self.stopController?.disableStartFlag()
        
        // state
        self.setStopButtons()
    }
    
    func reset() {
        do {
            try self.resetController?.resetLaps()
            self.laps.removeAll()
            self.setResetButtons()
        } catch {
            print(error)
        }
    }
}

/// Button Configure
extension _Stopwatch {
    private func setResetButtons() {
        self.components = ActionComponents {
            ActionComponent(title: "Lap", action: nil, style: .ckDisable, isDisable: true)
            ActionComponent(title: "Start", action: self.start, style: .ckGreen)
        }
    }
    private func setStartButtons() {
        self.components = ActionComponents {
            ActionComponent(title: "Lap", action: self.lap, style: .ckGray)
            ActionComponent(title: "Stop", action: self.stop, style: .ckRed)
        }
    }
    private func setStopButtons() {
        self.components = ActionComponents {
            ActionComponent(title: "Reset", action: self.reset, style: .ckGray)
            ActionComponent(title: "Start", action: self.start, style: .ckGreen)
        }
    }
}

private extension _Stopwatch {
    func didLoadLaps(_ target: Result<[Lap], any Error>) {
        switch target {
        case .success(let laps):
            self.laps = laps
        case .failure(let error):
            print(error)
        }
    }
    
    func didAddLap(_ target: Lap) {
        self.laps.insert(target, at: 0)
        
        if self.display == .watchface {
            self.display = .laplist
        }
    }
    
    func didChangeLifecycle(_ target: Bool) {
        self.components.leading.isActive = target
        self.components.trailing.isActive = target
    }
    
    func didChangeStartFlag(_ target: Bool) {
        if target {
            self.start()
        }
    }
    
    func didChangeProgress(_ target: Date) {
        self.laps[0].progress = target
    }
}
