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
