//
//  LapRow.swift
//  Stopwatch
//
//  Created by alphacircle on 1/6/26.
//

import SwiftUI

extension StopwatchScreen._StopwatchScreen.LapList {
    struct LapRow: View {
        private let _number: Text
        private let _split: Text
        private let _total: Text
        private let _font: Font
        private let _color: Color
        
        init(lap: Lap) {
            self.init(number: Text(lap.number),
                      split: Text(lap.progress, format: .stopwatch(startingAt: lap.split)),
                      total: Text(lap.progress, format: .stopwatch(startingAt: lap.total)),
                      font: nil,
                      color: nil)
        }
        
        init(number: String, split: String, total: String) {
            self.init(number: Text(number),
                      split: Text(split),
                      total: Text(total),
                      font: nil,
                      color: nil)
        }

        private init(number: Text, split: Text, total: Text, font: Font?, color: Color?) {
            self._number = number
            self._split = split
            self._total = total
            self._font = font ?? Font.callout
            self._color = color ?? CKColor.gray5
        }
        
        func attribute(font: Font? = nil, color: Color? = nil) -> Self {
            Self(number: _number, split: _split, total: _total, font: font, color: color)
        }
        
        var body: some View {
            HStack(spacing: 0.0) {
                _number.frame(maxWidth: .infinity, alignment: .leading)
                _split.frame(maxWidth: .infinity)
                _total.frame(maxWidth: .infinity, alignment: .trailing)
                Image
            }
            .font(_font)
            .foregroundStyle(_color)
        }
    }
}

#Preview {
    StopwatchScreen._StopwatchScreen.LapList.LapRow(number: "Lap 8", split: "00:00.34", total: "00:00.34")
        .padding()
}
