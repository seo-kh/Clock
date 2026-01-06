//
//  ClockButtonStyle.swift
//  Stopwatch
//
//  Created by alphacircle on 1/5/26.
//

import SwiftUI

struct ClockButtonStyle: ButtonStyle {
    let label: Color
    let background: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(Font.default)
            .foregroundStyle(label)
            .padding(.vertical, 6.0)
            .frame(width: 150.0)
            .background(configuration.isPressed ? background.mix(with: Color.white, by: 0.10) : background) // detect button click.
            .clipShape(Capsule())
    }
}

extension ClockButtonStyle {
    static var ckGreen: Self {
        Self(label: CKColor.label, background: CKColor.green)
    }
    
    static var ckGray: Self {
        Self(label: CKColor.label, background: CKColor.gray3)
    }
    
    static var ckRed: Self {
        Self(label: CKColor.label, background: CKColor.red)
    }
    
    static var ckDisable: Self {
        Self(label: CKColor.gray5, background: CKColor.gray2)
    }
}

extension ButtonStyle where Self == ClockButtonStyle {
    static var ckGreen: Self {
        Self(label: CKColor.label, background: CKColor.green)
    }
    
    static var ckGray: Self {
        Self(label: CKColor.label, background: CKColor.gray3)
    }
    
    static var ckRed: Self {
        Self(label: CKColor.label, background: CKColor.red)
    }
    
    static var ckDisable: Self {
        Self(label: CKColor.gray5, background: CKColor.gray2)
    }
}

#Preview {
    VStack(alignment: .center, spacing: 16.0) {
        Button("Green") {}
            .buttonStyle(.ckGreen)
        
        Button("Gray") {}
            .buttonStyle(.ckGray)
        
        Button("Red") {}
            .buttonStyle(.ckRed)
        
        Button("Disable") {}
            .buttonStyle(.ckDisable)
    }
    .padding()
    .background(CKColor.background)
}
