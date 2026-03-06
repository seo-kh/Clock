//
//  Tick.swift
//  WatchUI
//
//  Created by 테스트 on 2/28/26.
//

import Foundation

/// 눈금 데이터 모델
///
/// 기본(base) 인덱스와 세분(offset) 인덱스를 조합하여 눈금의 위치와 상태를 표현
///
/// ```swift
/// Scale(0..<12, times: 5) { tick in
///     ShapeMark(Rectangle(), anchor: .top)
///         .style(with: .color(tick.isBase ? .white : .gray))
///         .aspectRatio(tick.isBase ? 1.0/3.0 : 1.0/6.0)
///         .scale(tick.isBase ? 1.0 : 0.7)
/// }
/// ```
public struct Tick {
    /// 주 눈금 인덱스
    public let base: Int
    /// 세분 눈금 인덱스
    public let offset: Int
    /// 세분 단위 크기
    public let delta: TimeInterval
    /// base와 offset, delta를 조합한 실제 시간크기
    public var mark: TimeInterval {
        TimeInterval(base) + TimeInterval(offset) * delta
    }
    
    /// 주 눈금 여부
    public var isBase: Bool {
        offset == 0
    }
    
    /// 시작점 여부
    public var isOrigin: Bool {
        base == 0 && offset == 0
    }

    init(base: Int, offset: Int = 0, delta: TimeInterval = 1) {
        self.base = base
        self.offset = offset
        self.delta = delta
    }
    
    /// mark가 특정 값의 배수인지 확인
    ///
    /// > 부동소수점 허용 오차 0.0001
    public func isMultiple(of other: TimeInterval) -> Bool {
        let result = mark.truncatingRemainder(dividingBy: other)
        return abs(result) < 0.0001
    }
    
}

