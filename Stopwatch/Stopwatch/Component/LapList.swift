//
//  LapList.swift
//  Stopwatch
//
//  Created by alphacircle on 1/6/26.
//

import SwiftUI

extension StopwatchScreen._StopwatchScreen {
    struct LapList: View {
        let laps: [Lap]
        
        private var worstLap: Lap? {
            guard laps.count > 2 else { return nil }
            return laps.dropFirst().max()
        }
        
        private var bestLap: Lap? {
            guard laps.count > 2 else { return nil }
            return laps.dropFirst().min()
        }

        private var header: some View {
            Group {
                LapRow(number: "Lap No.", split: "Split", total: "Total")
                    .attribute(font: Font.callout, color: CKColor.gray5)
                
                Rectangle()
                    .frame(height: 1.0)
                    .foregroundStyle(CKColor.gray5) // divider
            }
        }
        
        var body: some View {
            VStack(alignment: .center, spacing: 0.0, content: {
                VStack(alignment: .center, spacing: 8.0, content: {
                    self.header
                        .frame(width: 300)
                }) // header
                
                ScrollView(.vertical, content: {
                    LazyVStack(alignment: .center, spacing: 0.0, content: {
                        ForEach(laps) { lap in
                            self.content(lap: lap, color: rank(for: lap))
                                .padding(.vertical, 4.0)
                        }
                        .frame(width: 300)
                    })
                }) // content
            })
        }
        
        private func rank(for lap: Lap) -> Color {
            switch lap.number {
            case worstLap?.number: return CKColor.red
            case bestLap?.number: return CKColor.green
            default: return CKColor.label
            }
        }
        
        private func content(lap: Lap, color: Color) -> some View {
            Group {
                LapRow(lap: lap)
                    .attribute(font: Font.default, color: color)
                
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundStyle(CKColor.gray5) // divider
            }
        }
    }
}

#Preview {
    StopwatchScreen._StopwatchScreen.LapList(laps: [
        Lap(number: 9, split: .now.addingTimeInterval(30), total: .now.addingTimeInterval(30), progress: .now.addingTimeInterval(90))
    ])
    .padding()
    .background(CKColor.background)
}
