# ``WatchUI``

시계 페이스(Watchface) 선언형 구성 프레임워크

## Overview

**WatchUI**는 SwiftUI의 `Canvas`를 기반으로 동작하는 **트리 기반 렌더링 시스템**입니다. 모든 구성 요소는 ``WatchContent`` 프로토콜을 구현하며, ``WatchContent/render(_:rect:)`` 메서드를 통해 `GraphicsContext`에 직접 그림을 그립니다.

---

**렌더링 흐름:**
1. ``Watchface``가 `Canvas`를 생성하고, 전체 크기의 `CGRect`를 루트 `rect`로 전달
2. 각 ``WatchContent``는 ``WatchContent/render(_:rect:)`` 에서 `rect`를 변환하거나 자식에게 전달
3. Marks는 최종적으로 `GraphicsContext`에 실제 드로잉을 수행

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

### Containers

- ``Layer``
- ``Scale``
- ``Index``
- ``Hand``
- ``Loop``

### Marks

- ``ShapeMark``
- ``TextMark``
- ``ImageMark``
