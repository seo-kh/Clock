# WatchUI로 시작하기

WatchUI로 시계 페이스(watch face)를 구성하기

## Overview


```
Watchface (SwiftUI View)
    └── WatchContent (protocol)
            ├── Marks (leaf nodes) — 실제 드로잉
            │       ├── ShapeMark
            │       ├── TextMark
            │       └── ImageMark
            ├── Containers (layout) — 자식을 배치
            │       ├── Layer
            │       ├── Scale
            │       ├── Index
            │       ├── Hand
            │       └── Loop
            └── Modifiers (transform) — rect 또는 context 변환
                    ├── FrameContent
                    ├── OffsetContent
                    ├── ScaleContent
                    ├── AspectRatioContent
                    ├── CoordinateRotatorContent
                    ├── AxisRotatorContent
                    └── OpacityContent
```

### Section header

<!--@START_MENU_TOKEN@-->Text<!--@END_MENU_TOKEN@-->
