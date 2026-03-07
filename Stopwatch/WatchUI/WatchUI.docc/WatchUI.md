# ``WatchUI``

시계 페이스(Watchface) 선언형 구성 프레임워크

## Overview

**WatchUI**는 SwiftUI의 `Canvas`를 기반으로 동작하는 **트리 기반 렌더링 시스템**입니다. \
모든 트리 구성 요소는 ``WatchContent`` 프로토콜을 구현하며, ``WatchContent/render(_:rect:)`` 메서드를 통해 콘텐츠를 그려냅니다.

WatchUI의 기본 콘텐츠들을 활용하여, 단순한 시계 페이스부터 복잡한 페이스까지 단순성과 가독성, 유지보수성 좋은 코드로 구현해 낼 수 있습니다.

@Links(visualStyle: detailedGrid) {
    - <doc:GettingStarted>
}

## Topics

### Essentials

- <doc:GettingStarted>

### Core

- ``WatchContent``
- ``WatchContentBuilder``
- ``Watchface``

### Supporting Contents

- ``AnyWatchContent``
- ``EmptyContent``
- ``TupleContent``

### Container Contents

- ``Layer``
- ``Scale``
- ``Index``
- ``Hand``
- ``Loop``

### Mark Contents

- ``ShapeMark``
- ``TextMark``
- ``ImageMark``
