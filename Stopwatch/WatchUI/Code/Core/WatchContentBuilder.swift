//
//  WatchContentBuilder.swift
//  WatchUI
//
//  Created by alphacircle on 2/6/26.
//

import Foundation

/// 콘텐츠를 구성하는 커스텀 파라미터 속성
///
/// `@resultBuilder`로 선언형 DSL 문법을 지원합니다. \
///  SwiftUI의 `@ViewBuilder`와 동일한 역할입니다.
@resultBuilder
public struct WatchContentBuilder {
    /// 빈 콘텐츠
    public static func buildBlock() -> EmptyContent {
        return EmptyContent()
    }
    
    /// 단일 콘텐츠
    public static func buildBlock<Content>(_ content: Content) -> Content where Content: WatchContent {
        return content
    }
    
    /// 다중 콘텐츠
    public static func buildBlock<each Content>(_ content: repeat each Content) -> TupleContent<(repeat each Content)> where repeat each Content: WatchContent {
        return TupleContent(contents: (repeat each content))
    }
    
    /// 참 조건식일때 콘텐츠
    public static func buildEither<TrueContent, FalseContent>(first content: TrueContent) -> _ConditionalWatchContent<TrueContent, FalseContent> where TrueContent: WatchContent, FalseContent: WatchContent {
        return _ConditionalWatchContent(trueContent: { content }, falseContent: nil)
    }
    
    /// 거짓 조건식일때 콘텐츠
    public static func buildEither<TrueContent, FalseContent>(second content: FalseContent) -> _ConditionalWatchContent<TrueContent, FalseContent> where TrueContent: WatchContent, FalseContent: WatchContent {
        return _ConditionalWatchContent(trueContent: nil, falseContent: { content })
    }

    /// 단일 콘텐츠
    public static func buildExpression<Content>(_ content: Content) -> Content where Content: WatchContent {
        return content
    }
    /// 옵셔널 콘텐츠
    public static func buildIf<Content>(_ content: Content?) -> Content? where Content: WatchContent {
        return content
    }
}
