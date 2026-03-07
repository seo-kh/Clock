# WatchUI로 시작하기

WatchUI로 시계 페이스(watch face)를 구성하기

@Metadata {
    @PageImage(purpose: card, source: "article", alt: "The demo image for watch face.")
}

## Overview

**WatchUI**는 시계 페이스 화면을 구성하기 위한 선언형 방법을 제공함으로 단순성과 가독성있게 코드를 작성할 수 있는 프레임워크입니다. 

아래와 같은 흐름으로 렌더링을 진행합니다. 

1. ``Watchface``가 `Canvas`를 생성하고, 전체 크기의 `CGRect`를 루트 `rect`로 전달
2. 각 ``WatchContent``는 ``WatchContent/render(_:rect:)`` 에서 `rect`를 변환하거나 자식에게 전달
3. Marks는 최종적으로 `GraphicsContext`에 실제 드로잉을 수행

### Watchface 선언하기

``Watchface``는 ``WatchContent``를 구현한 콘텐츠를 SwiftUI View에서 렌더링할 수 있는 진입점을 제공합니다. 내부적으로 `SwiftUI/Canvas`를 사용하여 ``WatchContent``를 렌더링합니다.

```swift
#Preview {
    Watchface {
        // 빈 콘텐츠
    }
}
```

### 시계 페이스 구조 정의하기

**WatchUI**에는 다양한 **Container Contents**가 존재합니다. 이를 이용해, 렌더링 기준점과 자식 콘텐츠의 사이즈 정의, 구성 요소를 쉽게 정의할 수 있습니다.

```swift
Watchface {
    Layer { // Layer Container
        Scale(0..<60) { tick in 

        } // Scale Container
    }

    Layer {
        Index(["60", "30"]) { sec in } // Index Container
    }
}
```

### 마크 콘텐츠 선언하기

**WatchUI**는 `-Mark` 접미어를 가진 콘텐츠가 존재합니다.
해당 콘텐츠는 렌더링 트리의 말단인 잎(leaf)에 해당하며, 최종 렌더링 주체입니다.

```swift
Watchface {
    ImageMark { Image(/../) }   // <- SwiftUI Image Mark
    TextMark { Text(/../) }     // <- SwiftUI Text Mark
    ShapeMark(Circle())         // <- SwiftUI Shape Mark
}
```

### 커스텀 콘텐츠 정의하기

**WatchUI**에서 제공하지 않는 커스텀 콘텐츠를 제작해야 한다면, ``WatchContent`` 프로토콜을 구현하세요. 구현한 타입을 ``Watchface`` 내부에서 자식 콘텐츠로 선언하세요.

```swift
// 커스텀 정의 예시
struct Bezel: WatchContent {
    func render(_ context: inout GraphicsContext, rect: CGRect) {
        // 구현 사항 정의..
    }
}
```
