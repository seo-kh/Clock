//
//  UpdateLifecycleUseCase.swift
//  Stopwatch
//
//  Created by alphacircle on 3/12/26.
//

import Foundation

protocol UpdateLifecycleUseCase {
    func updateLifecycle(command: UpdateLifecycleCommand)
}
