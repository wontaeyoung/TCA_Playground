# TCA의 요소들

TCA는 State, Action, Reducer, Environment, Store와 같은 객체들의 상호작용으로 이루어진다.

- State
    - 비즈니스 로직이나 UI에 필요한 데이터 혹은 상태를 설명하는 타입
- Action
    - 사용자 혹은 어플리케이션이 발생시킬 수 있는 모든 행동
- Environment
    - HTTP Client, Manager와 같이 어플리케이션이 필요로 하는 다른 혹은 외부 의존성을 관리하는 타입
- Reducer
    - Action에 대해서 State를 변경하는 로직을 가지고있는 타입
    - 추가적으로 다른 Action 혹은 Effect를 반환하며, 일반적으로 Effect를 반환함
- Store
    - 실제로 기능이 작동하는 공간
    - 런타임의 개념으로 생각함
    - Action의 발생이나 Reducer, Effect의 수행, State의 변화, UI 업데이트 등이 이루어지는 곳

# Action의 네이밍

Action의 case 이름은 어떤 로직을 수행하는지보다는, 어떤 상황에 발생하는지를 기반으로 작성한다.

로직 기반으로 이름을 작성하면 로직의 변경이 이루어지거나, 더 많은 동작을 수행해야할 때, 이름이 부적합하게 되어 변경해야하는 경우가 자주 생기기 때문이다.

# Reducer? ReducerOf?

AOf는 A를 더 편리하게 선언하기 위한 typealias이다.

```swift
Reducer<CounterFeature.State, CounterFeature.Action> 
→ 
ReducerOf<CounterFeature>
```

# Equatable

WithViewStore를 사용하기 위해서는 State가 Equatable을 준수해야한다.

- K: 포인트프리 튜토리얼에 printchanges 관련 내용으로 `값 타입은 참조와 달리 변경 전 값을 복사해서 변경 후 값과 비교할 수 있는 장점이 있다`는 언급이 있는데, 여기에 Equatable이 필요한 걸수도 있겠다.


# inout 파라미터와 클로저

inout 파라미터는 함수 내부의 또 다른 비동기 / 동시성 클로저에서 접근할 수 없다. inout 변수는 해당 함수에서만 임시적으로 수정할 수 있는 값 타입의 참조를 제공하며, 함수 내부에서 또 다른 클로저가 이에 접근하는 것은 쓰레드 세이프하지 않으며, 레이스 컨디션을 일으킬 수 있기 때문이다.

```swift
case .getFactButtonTapped:
  return .run { [count = state.count] send in
    try await URLSession.shared.data(
      from: URL(
        string: "http://www.numbersapi.com/\(count)"
      )!
    )
  }
```

그래서 위와 같은 방식으로 클로저 내부에서 캡처 리스트에 현재 외부 값을 한번 캡쳐한 다음에 사용함으로써 이러한 문제를 방지한다.
