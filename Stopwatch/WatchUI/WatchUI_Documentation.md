# WatchUI Framework 문서

> 시계 페이스(Watchface)를 선언적으로 구성하기 위한 SwiftUI Canvas 기반 커스텀 렌더링 프레임워크

---

## 목차

1. [아키텍처 개요](#아키텍처-개요)
2. [디렉토리 구조](#디렉토리-구조)
3. [Core — 핵심 프로토콜 및 빌더](#core)
4. [Containers — 레이아웃 컨테이너](#containers)
5. [Marks — 드로잉 리프 노드](#marks)
6. [Modifiers — 변환 수식어](#modifiers)
7. [Models/Size — 크기 규칙](#modelssize)
8. [Models/Alignment — 정렬 유틸리티](#modelsalignment)
9. [Models/Tick — 눈금 모델](#modelstick)
10. [사용 예시](#사용-예시)

---

## 아키텍처 개요

WatchUI는 SwiftUI의 `Canvas`를 기반으로 동작하는 **트리 기반 렌더링 시스템**입니다. 모든 구성 요소는 `WatchContent` 프로토콜을 구현하며, `render(_:rect:)` 메서드를 통해 `GraphicsContext`에 직접 그림을 그립니다.

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

**렌더링 흐름:**
1. `Watchface`가 `Canvas`를 생성하고, 전체 크기의 `CGRect`를 루트 `rect`로 전달
2. 각 `WatchContent`는 `render(_:rect:)` 에서 `rect`를 변환하거나 자식에게 전달
3. Marks는 최종적으로 `GraphicsContext`에 실제 드로잉을 수행

---

## 디렉토리 구조

```
Stopwatch/WatchUI/
├── WatchContent.swift           # 핵심 프로토콜 + 수식어 확장
├── WatchContentBuilder.swift    # @resultBuilder 정의
├── Watchface.swift              # 진입점 SwiftUI View
├── Containers/
│   ├── AnyWatchContent.swift    # 타입 소거(type-erase) 래퍼
│   ├── EmptyContent.swift       # 빈 콘텐츠
│   ├── TupleContent.swift       # 다중 콘텐츠 묶음
│   ├── Layer.swift              # 앵커 기반 레이어
│   ├── Hand.swift               # 시계 바늘 컨테이너
│   ├── Index.swift              # 원형 인덱스 배치
│   ├── Loop.swift               # 컬렉션 반복 렌더링
│   └── Scale.swift              # 눈금 레이아웃
├── Marks/
│   ├── ShapeMark.swift          # SwiftUI Shape 렌더링
│   ├── TextMark.swift           # 텍스트 렌더링
│   └── ImageMark.swift          # 이미지 렌더링
├── Modifiers/
│   ├── FrameContent.swift       # 명시적 크기 지정
│   ├── OffsetContent.swift      # 위치 이동
│   ├── ScaleContent.swift       # 크기 배율
│   ├── AspectRatioContent.swift # 가로세로 비율
│   ├── CoordinateRotatorContent.swift # 좌표계 회전
│   ├── AxisRotatorContent.swift # 원점 축 회전
│   └── OpacityContent.swift     # 불투명도
└── Models/
    ├── Tick.swift               # 눈금 위치 데이터
    ├── Alignment/
    │   └── UnitPoint+CG.swift   # UnitPoint → CGRect 정렬 유틸리티
    └── Size/
        ├── Size.swift           # 복합 크기 디스크립터
        ├── SizeRule.swift       # 크기 변환 규칙 프로토콜
        ├── AnySizeRule.swift    # 타입 소거 SizeRule
        ├── IdentitySizeRule.swift    # 원본 값 그대로 반환
        ├── FixedSizeRule.swift       # 고정 크기 반환
        ├── EqualSizeRule.swift       # 균등 분배 호 길이 계산
        └── PropotionalSizeRule.swift # 비율 스케일
```

---

## Core

### WatchContent.swift

**역할:** 프레임워크의 핵심 프로토콜. 모든 렌더링 가능한 요소가 구현해야 합니다.

```swift
public protocol WatchContent {
    func render(_ context: inout GraphicsContext, rect: CGRect)
}
```

| 메서드 | 설명 |
|--------|------|
| `render(_:rect:)` | 주어진 `GraphicsContext`와 `CGRect` 내에 콘텐츠를 그림 |

**`WatchContent` 기본 수식어 (extension):**

| 수식어 | 반환 타입 | 설명 |
|--------|-----------|------|
| `.coordinateRotation(angle:)` | `CoordinateRotatorContent` | 그래픽 좌표계 자체를 회전 |
| `.axisRotation(angle:)` | `AxisRotatorContent` | 원점(rect.origin)을 축으로 회전 |
| `.offset(_:)` / `.offset(x:y:)` | `OffsetContent` | rect의 origin을 이동 |
| `.scale(_:)` (CGFloat) | `ScaleContent` | 균일 배율 적용 |
| `.scale(_:)` (CGSize) | `ScaleContent` | X/Y 독립 배율 적용 |
| `.frame(width:height:)` | `FrameContent` | rect의 크기를 명시적으로 지정 |
| `.aspectRatio(_:)` | `AspectRatioContent` | width 기준으로 height를 비율로 결정 |
| `.opacity(_:)` | `OpacityContent` | 그래픽 컨텍스트의 불투명도 설정 |

---

### WatchContentBuilder.swift

**역할:** `@resultBuilder`로 선언형 DSL 문법을 지원합니다. SwiftUI의 `@ViewBuilder`와 동일한 역할입니다.

```swift
@resultBuilder
public struct WatchContentBuilder { ... }
```

| 메서드 | 설명 |
|--------|------|
| `buildBlock()` | 빈 블록 → `EmptyContent` 반환 |
| `buildBlock<Content>(_:)` | 단일 콘텐츠 → 그대로 반환 |
| `buildBlock<each Content>(_:)` | 다중 콘텐츠 → `TupleContent`로 묶어 반환 (parameter pack 사용) |
| `buildExpression(_:)` | 표현식 → 그대로 반환 |
| `buildOptional(_:)` | 옵셔널 콘텐츠 지원 |

---

### Watchface.swift

**역할:** WatchUI 프레임워크의 진입점. `WatchContent` 트리를 SwiftUI `Canvas`로 렌더링합니다.

```swift
public struct Watchface<Content: WatchContent>: View
```

| 파라미터 | 타입 | 설명 |
|----------|------|------|
| `content` | `@WatchContentBuilder () -> Content` | 렌더링할 콘텐츠 트리 |

**동작:**
- `Canvas`를 생성하고, 캔버스 전체 영역을 루트 `rect`로 전달
- `content()`를 호출하여 `WatchContent` 트리를 `render`

---

## Containers

### Layer.swift

**역할:** 특정 앵커 포인트를 원점으로 이동시켜 자식 콘텐츠를 배치합니다. 시계 페이스에서 요소를 중앙, 상단 등 특정 위치에 고정할 때 사용합니다.

```swift
public struct Layer<Content: WatchContent>: WatchContent
```

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `anchor` | `UnitPoint` | `.center` | 자식 콘텐츠의 원점이 될 위치 |
| `content` | `@WatchContentBuilder () -> Content` | — | 그릴 콘텐츠 |

**동작:**
- `drawLayer`로 격리된 그래픽 레이어 생성
- `anchor`를 `UnitPoint.alignOriginPoint(to:)`로 변환하여 컨텍스트를 translate

**예시:**
```swift
Layer(anchor: .center) {
    ShapeMark(Circle(), anchor: .center)
        .frame(width: 50, height: 50)
}
```

---

### Scale.swift

**역할:** 원형 눈금(tick mark) 레이아웃을 구성합니다. `Size`를 사용해 각 눈금의 크기를 정의하며, 간편 이니셜라이저로 `Range<Int>`를 받아 자동으로 각도와 `Tick` 정보를 계산합니다.

```swift
public struct Scale<Content: WatchContent>: WatchContent
```

**기본 이니셜라이저:**

| 파라미터 | 타입 | 설명 |
|----------|------|------|
| `size` | `Size` | 눈금 영역의 크기 규칙 |
| `content` | `() -> Content` | 그릴 콘텐츠 |

**편의 이니셜라이저 (`Content == AnyWatchContent`):**

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `interval` | `Range<Int>` | — | 눈금의 기본(base) 범위 |
| `times` | `Int` | `1` | 각 base 당 세분 눈금 수 |
| `period` | `Int` | `1` | 전체 반복 주기 |
| `scaleContent` | `(Tick) -> R` | — | 각 눈금을 그리는 클로저 |

**계산 로직:**
- `tickCount = interval.count × times`
- `total = tickCount × period`
- 각 눈금 각도 = `360° / tickCount`
- `Size.width = .equal(total:)` 로 눈금 너비를 원주에 균등 분배

**예시:**
```swift
Scale(0..<60) { tick in
    ShapeMark(Rectangle(), anchor: .top)
        .style(with: .color(tick.isBase ? .white : .gray))
        .aspectRatio(tick.isBase ? 1.0/3.0 : 1.0/5.0)
}
```

---

### Index.swift

**역할:** `RandomAccessCollection`의 각 요소를 원형으로 균등 배치합니다. 시계 숫자판(12, 3, 6, 9 등)을 구성할 때 사용합니다.

```swift
public struct Index<Content: WatchContent>: WatchContent
```

**편의 이니셜라이저:**

| 파라미터 | 타입 | 설명 |
|----------|------|------|
| `data` | `D: RandomAccessCollection` | 배치할 데이터 컬렉션 |
| `indexContent` | `(D.Element) -> R` | 각 요소를 그리는 클로저 |

**동작:**
- 컬렉션 원소 수에 따라 원주를 균등 분배 (2π / count)
- 각 요소에 `axisRotation`을 적용하여 원형 배치
- 내부적으로 `Loop` + `AnyWatchContent` 조합으로 구현

**예시:**
```swift
Index(["12", "3", "6", "9"]) { label in
    TextMark(anchor: .center) {
        Text(label).foregroundStyle(.white)
    }
}
.frame(width: 160, height: 160)
```

---

### Hand.swift

**역할:** 시계 바늘을 위한 컨테이너. `Size`를 사용해 바늘의 크기 영역을 정의하고, 자식 콘텐츠에 계산된 `CGRect`를 전달합니다.

```swift
public struct Hand<T: WatchContent>: WatchContent
```

| 파라미터 | 타입 | 설명 |
|----------|------|------|
| `size` | `Size` | 바늘 영역의 크기 규칙 |
| `content` | `() -> T` | 바늘로 그릴 콘텐츠 |

**동작:**
- `min(rect.width, rect.height) / 2`를 반지름으로 사용
- `size.makeCGRect(length: radius)`로 자식에게 전달할 rect 계산

**예시:**
```swift
Hand(size: .init(width: .equal(total: 180))) {
    ShapeMark(Rectangle(), anchor: .top)
        .style(with: .color(.orange))
        .coordinateRotation(angle: currentAngle)
}
```

---

### Loop.swift

**역할:** `RandomAccessCollection`의 모든 요소를 순서대로 렌더링합니다. SwiftUI `ForEach`와 유사합니다.

```swift
public struct Loop<Data: RandomAccessCollection, Content: WatchContent>: WatchContent
```

| 파라미터 | 타입 | 설명 |
|----------|------|------|
| `data` | `Data` | 반복할 컬렉션 |
| `content` | `(Data.Element) -> Content` | 각 요소를 그리는 클로저 |

**예시:**
```swift
Loop(data: 0..<60) { i in
    ShapeMark(Rectangle(), anchor: .top)
        .coordinateRotation(angle: .degrees(6.0 * Double(i)))
}
```

---

### AnyWatchContent.swift

**역할:** `WatchContent`의 타입 소거(type erasure) 래퍼. 구체적인 타입을 숨기고 `any WatchContent`로 저장합니다.

```swift
public struct AnyWatchContent: WatchContent
```

| 이니셜라이저 | 설명 |
|-------------|------|
| `init(content: any WatchContent)` | 존재형 타입으로 초기화 |
| `init<C: WatchContent>(content: () -> C)` | 클로저로 초기화 |

---

### EmptyContent.swift

**역할:** 아무것도 그리지 않는 빈 콘텐츠. `WatchContentBuilder.buildBlock()`이 빈 블록일 때 반환합니다.

```swift
public struct EmptyContent: WatchContent
```

---

### TupleContent.swift

**역할:** 여러 `WatchContent`를 하나로 묶습니다. `WatchContentBuilder`의 `buildBlock`이 다중 요소를 받을 때 생성됩니다. Swift parameter pack(`repeat each`)을 활용합니다.

```swift
public struct TupleContent<T>: WatchContent
```

**동작:**
- `init<each Content: WatchContent>(contents:)` 에서 `(repeat each Content)` 튜플을 저장
- `render`시 튜플의 각 요소를 순회하며 렌더링

---

## Marks

### ShapeMark.swift

**역할:** SwiftUI `Shape`를 `GraphicsContext`에 채워서 그립니다.

```swift
public struct ShapeMark<S: Shape>: WatchContent
```

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `shape` | `S: Shape` | — | 그릴 SwiftUI Shape |
| `anchor` | `UnitPoint` | `.center` | 드로잉 기준점. rect와 shape를 정렬하는 방법 결정 |
| `shading` | `GraphicsContext.Shading` | `.foreground` | 채움 색상 또는 그라디언트 |

**수식어:**

| 메서드 | 설명 |
|--------|------|
| `.style(with:)` | 새로운 shading 적용, 새 `ShapeMark` 반환 |

**앵커 정렬 방식:**
- `anchor.alignAnchorPoint(to: rect)`를 통해 shape가 그려질 최종 rect를 계산
- 예: `anchor: .top`이면 shape의 상단이 `rect.origin`에 맞춰짐

**예시:**
```swift
ShapeMark(Rectangle(), anchor: .top)
    .style(with: .color(.red))
    .frame(width: 4, height: 60)
```

---

### TextMark.swift

**역할:** `Text` 뷰를 `GraphicsContext`에 그립니다.

```swift
public struct TextMark: WatchContent
```

| 이니셜라이저 | 설명 |
|-------------|------|
| `init(anchor:content:)` | `Text` 뷰 클로저로 초기화 |
| `init(text:anchor:)` | 문자열로 간편 초기화 |

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `anchor` | `UnitPoint` | `.center` | `GraphicsContext.draw(text:at:anchor:)`의 anchor |

**예시:**
```swift
TextMark(anchor: .center) {
    Text("12")
        .font(.system(size: 14, weight: .bold))
        .foregroundStyle(.white)
}
```

---

### ImageMark.swift

**역할:** `Image` 뷰를 `GraphicsContext`에 그립니다.

```swift
public struct ImageMark: WatchContent
```

| 이니셜라이저 | 설명 |
|-------------|------|
| `init(anchor:content:)` | `Image` 클로저로 초기화 |
| `init(systemName:anchor:)` | SF Symbol 이름으로 간편 초기화 |

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `anchor` | `UnitPoint` | `.center` | 이미지 배치 기준점 |

**예시:**
```swift
ImageMark(systemName: "clock")
    .frame(width: 40, height: 40)
```

---

## Modifiers

모든 Modifier는 `WatchContent` extension의 수식어 메서드를 통해 적용하며, 직접 초기화하지 않습니다.

---

### FrameContent.swift

**역할:** 자식 콘텐츠에 전달되는 `rect`의 width/height를 명시적으로 지정합니다.

```swift
struct FrameContent<Content: WatchContent>: WatchContent
```

| 파라미터 | 타입 | 설명 |
|----------|------|------|
| `width` | `CGFloat?` | 지정하지 않으면 부모의 width 사용 |
| `height` | `CGFloat?` | 지정하지 않으면 부모의 height 사용 |

**적용:** `.frame(width:height:)`

---

### OffsetContent.swift

**역할:** `rect.origin`을 X/Y 방향으로 이동합니다.

```swift
struct OffsetContent<Content: WatchContent>: WatchContent
```

| 파라미터 | 타입 | 설명 |
|----------|------|------|
| `offset` | `CGPoint` | 이동량 |

**적용:** `.offset(_:)` / `.offset(x:y:)`

---

### ScaleContent.swift

**역할:** `rect.size`를 X/Y 독립적으로 배율 변환합니다.

```swift
struct ScaleContent<Content: WatchContent>: WatchContent
```

| 파라미터 | 타입 | 설명 |
|----------|------|------|
| `size` | `CGSize` | 각 축의 배율 (width: X배율, height: Y배율) |

**적용:** `.scale(_ s: CGFloat)` / `.scale(_ scale: CGSize)`

---

### AspectRatioContent.swift

**역할:** `rect.width`를 기준으로 `rect.height = width / aspectRatio`를 계산합니다.

```swift
struct AspectRatioContent<Content: WatchContent>: WatchContent
```

| 파라미터 | 타입 | 설명 |
|----------|------|------|
| `aspectRatio` | `CGFloat` | width : height 비율 (예: `1.0/3.0` → 높이가 너비의 3배) |

**적용:** `.aspectRatio(_:)`

> **주의:** `.frame(height:)`보다 우선 적용됨. `aspectRatio`가 설정되면 frame의 height는 무시됩니다.

---

### CoordinateRotatorContent.swift

**역할:** `GraphicsContext` 자체를 회전시킵니다. 이후 그려지는 모든 콘텐츠가 회전된 좌표계에서 그려집니다.

```swift
struct CoordinateRotatorContent<Content: WatchContent>: WatchContent
```

| 파라미터 | 타입 | 설명 |
|----------|------|------|
| `angle` | `Angle` | 회전 각도 |

**동작:**
- `context.rotate(by: angle)` 호출 후 자식 렌더링
- `Scale`의 눈금 배치에서 각 tick을 회전할 때 주로 사용

**적용:** `.coordinateRotation(angle:)`

---

### AxisRotatorContent.swift

**역할:** `rect.origin`을 원점 축 기준으로 회전합니다. `GraphicsContext`는 변경하지 않고 rect의 origin 좌표만 회전 변환합니다.

```swift
struct AxisRotatorContent<Content: WatchContent>: WatchContent
```

| 파라미터 | 타입 | 설명 |
|----------|------|------|
| `angle` | `Angle` | 회전 각도 |

**동작:**
- `CGAffineTransform(rotationAngle:)`으로 `rect.origin`만 변환
- `rect.origin`이 `zero`인 경우 회전이 동작하지 않음 (주석 참고)
- `Index`의 원형 배치에서 항목 위치를 회전할 때 사용

**적용:** `.axisRotation(angle:)`

> `CoordinateRotatorContent`와의 차이: `coordinateRotation`은 드로잉 컨텍스트를 회전(이후 그림이 모두 회전됨), `axisRotation`은 위치(origin)만 회전.

---

### OpacityContent.swift

**역할:** `GraphicsContext.opacity`를 변경하여 자식 콘텐츠의 불투명도를 조절합니다.

```swift
struct OpacityContent<Content: WatchContent>: WatchContent
```

| 파라미터 | 타입 | 설명 |
|----------|------|------|
| `opacity` | `Double` | 불투명도 (0.0 ~ 1.0) |

**동작:**
- 자식 렌더링 후 `context.opacity`를 `1.0`으로 복원

**적용:** `.opacity(_:)`

---

## Models/Size

### SizeRule.swift (프로토콜)

**역할:** 반지름(radius) 등 기준 길이(`original`)를 받아 실제 크기를 계산하는 규칙 프로토콜입니다.

```swift
public protocol SizeRule {
    func transform(from original: CGFloat) -> CGFloat
}
```

**팩토리 메서드 (static):**

| 메서드 | 반환 타입 | 설명 |
|--------|-----------|------|
| `.fixed(_ size:)` | `FixedSizeRule` | 항상 고정 값 반환 |
| `.equal(total:)` | `EqualSizeRule` | 원주를 total로 균등 분배한 호 길이 |
| `.identity` | `IdentitySizeRule` | 원본 값 그대로 |
| `.propotional(_ ratio:)` | `PropotionalSizeRule` | 원본 × ratio |

---

### Size.swift

**역할:** 컨테이너(`Scale`, `Hand`, `Index`)에서 자식에게 전달할 `CGRect`를 생성합니다. x, y, width, height 각각에 독립적인 `SizeRule`을 적용합니다.

```swift
public struct Size
```

| 프로퍼티 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `x` | `SizeRule` | `.fixed(0)` | x 오프셋 (결과 rect에서 `-x` 적용) |
| `y` | `SizeRule` | `.identity` | y 오프셋 (결과 rect에서 `-y` 적용) |
| `width` | `SizeRule` | `.identity` | rect의 width |
| `height` | `SizeRule` | `.identity` | rect의 height |

**메서드:**

```swift
func makeCGRect(length: CGFloat) -> CGRect
```

- 각 SizeRule에 `length`를 전달하여 변환
- 반환: `CGRect(x: -x, y: -y, width: width, height: height)`

---

### FixedSizeRule.swift

```swift
public struct FixedSizeRule: SizeRule
```

- `transform(from:)` → 항상 `self.size` 반환
- 사용: 픽셀 단위 고정 크기가 필요할 때

---

### EqualSizeRule.swift

```swift
public struct EqualSizeRule: SizeRule
```

- `transform(from original:)` → `2π × original / total`
- 원의 둘레를 `total`로 균등 분배한 호 길이 계산
- 사용: 눈금을 원주에 균등 배치할 때 각 눈금의 너비를 계산

---

### IdentitySizeRule.swift

```swift
public struct IdentitySizeRule: SizeRule
```

- `transform(from original:)` → `original` 그대로 반환
- 사용: 부모 크기를 그대로 사용할 때

---

### PropotionalSizeRule.swift

```swift
public struct PropotionalSizeRule: SizeRule
```

- `transform(from original:)` → `original × ratio`
- 사용: 반지름의 일정 비율로 크기를 결정할 때

---

### AnySizeRule.swift

```swift
public struct AnySizeRule: SizeRule
```

- 내부에 `any SizeRule`을 저장하는 타입 소거 래퍼
- `transform(from:)` → 내부 rule에 위임

---

## Models/Alignment

### UnitPoint+CG.swift

**역할:** `UnitPoint`를 이용해 `CGRect`를 정렬하는 두 가지 메서드를 제공합니다.

```swift
extension UnitPoint
```

| 메서드 | 반환 타입 | 설명 |
|--------|-----------|------|
| `alignOriginPoint(to rect:)` | `CGPoint` | Layer에서 사용: rect 내에서 anchor에 해당하는 절대 좌표 계산 |
| `alignAnchorPoint(to rect:)` | `CGRect` | ShapeMark에서 사용: rect를 anchor 방향으로 이동하여 기준점 정렬 |

**`alignOriginPoint` 동작:**
```
결과 = origin + (size.width × anchor.x, size.height × anchor.y)
```
→ `Layer`가 자식의 원점을 화면의 anchor 위치로 이동할 때 사용

**`alignAnchorPoint` 동작:**
```
결과 origin = origin - (size.width × anchor.x, size.height × anchor.y)
```
→ `ShapeMark`가 shape의 특정 지점(예: 상단 중앙)을 드로잉 기준점에 맞출 때 사용

---

## Models/Tick

### Tick.swift

**역할:** `Scale`의 눈금 하나를 나타내는 데이터 모델입니다. 기본(base) 인덱스와 세분(offset) 인덱스를 조합하여 눈금의 위치와 상태를 표현합니다.

```swift
public struct Tick
```

| 프로퍼티 | 타입 | 설명 |
|----------|------|------|
| `base` | `Int` | 주 눈금 인덱스 |
| `offset` | `Int` | 세분 눈금 인덱스 (0 = 주 눈금) |
| `delta` | `TimeInterval` | 세분 단위 크기 (`1.0 / times`) |
| `mark` | `TimeInterval` | 연산 프로퍼티: `base + offset × delta` (절대 위치값) |
| `isBase` | `Bool` | `offset == 0` — 주 눈금 여부 |
| `isOrigin` | `Bool` | `base == 0 && offset == 0` — 시작점 여부 |

**메서드:**

| 메서드 | 설명 |
|--------|------|
| `isMultiple(of:)` | `mark`가 특정 값의 배수인지 확인 (부동소수점 허용 오차 0.0001) |

**사용 예시:**
```swift
Scale(0..<12, times: 5) { tick in
    ShapeMark(Rectangle(), anchor: .top)
        .style(with: .color(tick.isBase ? .white : .gray))
        .aspectRatio(tick.isBase ? 1.0/3.0 : 1.0/6.0)
        .scale(tick.isBase ? 1.0 : 0.7)
}
```

---

## 사용 예시

### 기본 시계 페이스

```swift
Watchface {
    // 눈금판
    Layer(anchor: .center) {
        Scale(0..<60, times: 1) { tick in
            ShapeMark(Rectangle(), anchor: .top)
                .style(with: .color(tick.isMultiple(of: 5) ? .white : .gray))
                .aspectRatio(tick.isMultiple(of: 5) ? 1.0/3.0 : 1.0/6.0)
                .scale(tick.isMultiple(of: 5) ? 1.0 : 0.7)
        }
        .frame(width: 280, height: 280)
    }

    // 숫자 인덱스
    Layer(anchor: .center) {
        Index(["12","1","2","3","4","5","6","7","8","9","10","11"]) { label in
            TextMark(anchor: .center) {
                Text(label)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white)
            }
        }
        .frame(width: 220, height: 220)
    }

    // 분침
    Layer(anchor: .center) {
        Hand(size: .init(width: .equal(total: 180))) {
            ShapeMark(RoundedRectangle(cornerRadius: 2), anchor: .bottom)
                .style(with: .color(.white))
                .frame(width: 3, height: 100)
                .coordinateRotation(angle: minuteAngle)
        }
    }

    // 시침
    Layer(anchor: .center) {
        Hand(size: .init(width: .equal(total: 180))) {
            ShapeMark(RoundedRectangle(cornerRadius: 2), anchor: .bottom)
                .style(with: .color(.white))
                .frame(width: 5, height: 70)
                .coordinateRotation(angle: hourAngle)
        }
    }

    // 중심점
    Layer(anchor: .center) {
        ShapeMark(Circle(), anchor: .center)
            .style(with: .color(.orange))
            .frame(width: 8, height: 8)
    }
}
```

---

*문서 생성일: 2026-03-03*
