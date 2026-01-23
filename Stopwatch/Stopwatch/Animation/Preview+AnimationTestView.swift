//
//  Preview+AnimationTestView.swift
//  Stopwatch
//
//  Created by alphacircle on 1/22/26.
//

import SwiftUI

private struct AnimationTestView: View {
    @State private var isTransition = false
    
    var body: some View {
        VStack {
            Group {
                if isTransition {
                    Spacer()
                    Rectangle()
                        .fill(Color.pink)
                        .frame(width: 200, height: 200)
                        .onTapGesture {
                            isTransition.toggle()
                        }
                        .transition(.delayAppear(for: 0.15))
                    Spacer()
                } else {
                    Rectangle()
                        .fill(Color.orange)
                        .frame(width: 300, height: 100)
                        .onTapGesture {
                            isTransition.toggle()
                        }
                        .transition(.downUp(y: 150))

                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 300)
                        .transition(.up(y: 220))
                }
            } // GROUP
            .animation(.linear(duration: 0.3), value: isTransition)
            
            Rectangle()
                .frame(height: 80)
        }
    }
}

#Preview {
    AnimationTestView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
}
