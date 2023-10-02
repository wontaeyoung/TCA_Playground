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


# TCA의 상태 관리 원리 (inout)

**`Store`** 객체가 생성될 때, **`Reducer`**의 **`State`** 인스턴스가 생성된다.

**`State`**는 **`struct`**로 선언된 값 타입이지만, **`inout`**으로 **`Reduce`**에 전달되어 값 타입임에도 참조 타입처럼 **`State`**를 직접 업데이트할 수 있는 것이다.

**값 타입의 `State`**

- TCA에서 **`State`**는 값 타입(주로 **`struct`**)으로 정의된다. 값 타입은 참조 타입과는 다르게 복사할 때마다 새 인스턴스가 생기는데, 그래서 원래 값은 변하지 않아서 상태 변경이 예측 가능하고 안전하게 처리된다.

**`Store`와 `inout`**

- **`Store`**는 앱의 현재 **`State`**를 가지고 있다. 리듀서는 액션을 처리할 때 이 **`State`**를 **`inout`**로 받아 직접 수정할 수 있다. **`inout`** 덕분에, 리듀서 내에서 상태를 직접 수정하는 건데, 그 변경은 **`Store`**에 저장된 원래 상태에도 반영된다.

**참조 타입처럼 동작**

- **`inout`**를 사용해서 값 타입인 **`State`**가 참조 타입처럼 동작시킬 수 있다. 그래서 **`Reducer`**의 **`Action`** 내에서 **`State`**의 수정은 원래 **`State`**에도 영향을 준다. 반대로 **`Reducer`**가 아니면 의도적으로 **`State`**를 **`inout`**으로 전달하지 않는 이상 값 타입으로 동작하므로 다른 책임에서의 상태 변경을 방지할 수 있다.

요약하면 TCA는 값 타입의 안정성과 참조 타입의 편리성을 모두 활용하여 상태를 안전하게 관리한다!

# **Effect의 run 함수**

## **궁금점**

1. **`Send<Action>`**은 구조체나 클래스처럼 생겼는데 정체가 무엇인가?
2. **`send`**가 클로저라면 **`run`**의 **`operation`** 클로저 내부에서 필요한만큼 **`send`**를 통해 추가 액션을 전달할 수 있는것인가?

```swift
static func run(
    priority: TaskPriority? = nil,
    operation: @escaping (Send<CounterFeature.Action>) async throws -> Void,
    catch handler: ((Error, Send<CounterFeature.Action>) async -> Void)? = nil,
    fileID: StaticString = #fileID,
    line: UInt = #line
) -> Effect<CounterFeature.Action>
```

**`operation`** 클로저를 작성해서 사용한다. 파라미터인 **`send`**는 **Action** 타입을 받는 클로저이며, **`send`**를 통해서 원하는만큼 추가적인 다른 액션을 수행할 수 있다.

클로저가 async로 선언되어 있기 때문에 비동기로 작동하며, 발생하는 에러에 대해서 catch 클로저에서 처리할 수 있다.

**`Send<Action>`**이 클로저라면 반환 타입이 존재해야하는데, 실제로 암묵적으로 작성된 것으로 보이며 내부 타입 선언을 추론해보면 아래와 같을 것 같다.

```swift
typealias Send<Action> = (Action) -> Void
```

위에서 설명한 것처럼 클로저가 비동기 블록이기 때문에, `send` 클로저를 사용하려면 `await`이 필요하다.

만약 `run` 스코프 내에서 동기적으로 `send`를 사용하고싶지 않다면, 아래 방식처럼 `Task` 블록으로 감싸서 사용해야한다.

```swift
Effect.run { send in
    Task {
        await send(.someAction)
    }
        await send(.anotherAction)
    return .none
}
```

# Store의 이니셜라이징

```swift
// 파라미터 선언
let store: Store<CounterFeature.State, CounterFeature.Action>

// 초기화
ContentView(
    store: Store(initialState: CounterFeature.State()) {
        CounterFeature()
    }, storeOf: nil
)
```

## 궁금점

`Store<CounterFeature.State, CounterFeature.Action>` 타입에 `Store(initialState: , reducer: )`를 통해 초기화하는데, reducer에 전달한 아규먼트로 제네릭으로 선언된 State와 Action의 추론이 가능해지는 것인가?

```swift
public final class Store<State, Action> {
  ...
  private let reducer: any Reducer<State, Action>
  ...
  public convenience init<R: Reducer>(
    initialState: @autoclosure () -> R.State,
    @ReducerBuilder<State, Action> reducer: () -> R,
    withDependencies prepareDependencies: ((inout DependencyValues) -> Void)? = nil
  )
```

위는 `Store`의 내부 구조다. `reducer` 프로퍼티를 초기화하기 위해 이니셜라이저에서 `reducer () → R` 클로저를 전달받고, `Reducer` 인스턴스를 생성할 때, `Reducer`에 포함된 `State`와 `Action`이 전달되면서 제네릭의 타입을 추론하게된다.
