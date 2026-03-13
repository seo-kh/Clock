//
//  ActionComponent.swift
//  Stopwatch
//
//  Created by james seo on 1/6/26.
//

import Foundation

struct ActionComponents: Equatable {
    var leading: ActionComponent
    var trailing: ActionComponent
    
    init(leading: ActionComponent, trailing: ActionComponent) {
        self.leading = leading
        self.trailing = trailing
    }
    
    init(@ActionBuilder _ builder: () -> ActionComponents) {
        self = builder()
    }
}

@resultBuilder
struct ActionBuilder {
    static func buildBlock(_ leading: ActionComponent, _ trailing: ActionComponent) -> ActionComponents {
        ActionComponents(leading: leading, trailing: trailing)
    }
}

extension ActionComponents {
    static var idle: Self {
        ActionComponents {
            ActionComponent(title: "Lap", action: nil, style: .ckDisable)
            ActionComponent(title: "Start", action: {}, style: .ckGreen)
        }
    }
    
    static var start: Self {
        ActionComponents {
            ActionComponent(title: "Lap", action: {}, style: .ckGray)
            ActionComponent(title: "Stop", action: {}, style: .ckRed)
        }
    }
    
    static var stop: Self {
        ActionComponents {
            ActionComponent(title: "Reset", action: {}, style: .ckGray)
            ActionComponent(title: "Start", action: {}, style: .ckGreen)
        }
    }
}

struct ActionComponent: Identifiable, Equatable {
    static func == (lhs: ActionComponent, rhs: ActionComponent) -> Bool {
        return lhs.title == rhs.title &&
        lhs.primitive == rhs.primitive &&
        lhs.isActive == rhs.isActive &&
        lhs.isDisable == rhs.isDisable
    }
    
    let title: String
    let action: (() -> Void)?
    private let primitive: ClockButtonStyle
    var isActive: Bool
    var isDisable: Bool
    
    init(title: String, action: (() -> Void)?, style: ClockButtonStyle, isDisable: Bool = false) {
        self.title = title
        self.action = action
        self.primitive = style
        self.isDisable = isDisable
        self.isActive = true
    }
    
    var id: String { self.title }
    
    var style: ClockButtonStyle {
        if isDisable {
            return ClockButtonStyle.ckDisable
        } else if isActive {
            return primitive
        } else {
            return ClockButtonStyle.ckGray
        }
    }
}

