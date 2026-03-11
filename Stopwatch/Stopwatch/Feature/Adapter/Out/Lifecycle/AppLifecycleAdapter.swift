//
//  AppLifecycleAdapter.swift
//  Stopwatch
//
//  Created by alphacircle on 3/11/26.
//

import Foundation
import AppKit

final class AppLifecycleAdapter: ListenLifecyclePort {
    private var callback: ((Bool) -> Void)? = nil
    private let activeNotification = NSApplication.didBecomeActiveNotification
    private let inactiveNotification = NSApplication.didResignActiveNotification

    func listen(callback: @escaping (Bool) -> Void) {
        self.callback = callback
        
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(setActive),
                         name: activeNotification,
                         object: nil)
        
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(setInactive),
                         name: inactiveNotification,
                         object: nil)
    }
    
    @objc
    private func setActive(_ notification: Notification) {
        self.callback?(true)
    }
    
    @objc
    private func setInactive(_ notification: Notification) {
        self.callback?(false)
    }
}
