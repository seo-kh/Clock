//
//  StopwatchFace.swift
//  Stopwatch
//
//  Created by alphacircle on 1/9/26.
//

import SwiftUI

/// 시계화면 UI
///
/// [용어의 정리]
/// 1. Hand: 시침, 분침, 초침 같은 시곗바늘
/// 2. Index: 시각을 표시하는 숫자, 기호
/// 3. Scale: Index 사이의 작은 눈금표시
/// 4. Window: 날짜나 기타 정보를 표시하는 창
/// 5. Face: 1~4의 모든 요소를 포함하는 전체
///
/// 참고링크: [알아 두면 도움 되는 시계 용어](https://magazine.hankyung.com/money/article/202101206538c)
struct StopwatchFace: View {
    var body: some View {
        Canvas { context, size in
            let rect = CGRect(origin: .zero, size: size)
            context.fill(Circle().path(in: rect), with: .color(Color.yellow))
        }
    }
}

#Preview {
    StopwatchFace()
        .frame(width: 500, height: 500)
        .padding()
}
