//
//  NotificationAppActivationSource.swift
//  Stopwatch
//
//  Created by alphacircle on 3/30/26.
//

import Foundation
import Combine
#if os(macOS)
import Cocoa
#else
import UIKit
#endif

final class NotificationAppActivationSource: AppActivationSource {
    private var cancellables: Set<AnyCancellable> = []
    
    func start(onUpdate: @escaping (Result<Bool, any Error>) -> Void) {
                let activeNotification: Notification.Name
                let inactiveNotification: Notification.Name
        
                #if os(macOS)
                activeNotification = NSApplication.didBecomeActiveNotification
                inactiveNotification = NSApplication.didResignActiveNotification
                #else
                activeNotification = UIApplication.didBecomeActiveNotification
                inactiveNotification = UIApplication.didEnterBackgroundNotification
                #endif
        
                NotificationCenter.default
                    .publisher(for: activeNotification)
                    .sink(receiveValue: { _ in
                        onUpdate(Result.success(true))
                    })
                    .store(in: &cancellables)
        
                NotificationCenter.default
                    .publisher(for: inactiveNotification)
                    .sink(receiveValue: { _ in
                        onUpdate(Result.success(false))
                    })
                    .store(in: &cancellables)
    }
    
    func stop(completion: @escaping ((any Error)?) -> Void) {
        self.cancellables.forEach({ $0.cancel() })
        self.cancellables.removeAll()
    }
}

