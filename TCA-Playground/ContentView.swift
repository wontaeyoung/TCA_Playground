import ComposableArchitecture
import SwiftUI

struct CounterFeature: Reducer {
    struct State: Equatable {
        var number: Int = 0
        var factString: String? = nil
        var isTimerOn: Bool = false
        var isLoadingFact: Bool = false
    }
    
    enum Action: Equatable {
        case incrementButtonTapped
        case decrementButtonTapped
        case getFactButtonTapped
        case toggleTimerButtonTapped
        
        case factResponse(fact: String)
        case timerTicked
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .incrementButtonTapped:
                state.number += 1
                
                return .none
                
            case .decrementButtonTapped:
                decreaseNumber(num: &state.number)
                
                return .none
                
            case .getFactButtonTapped:
                state.isLoadingFact = true
                @Dependency(\.numberFact) var numberFact: NumberFactClient
                
                return .run { [someNumber = state.number] send in
                    let numberFactResult: String = try await numberFact.fetch(someNumber)
                    
                    await send(.factResponse(fact: numberFactResult))
                }
                
            case .toggleTimerButtonTapped:
                state.isTimerOn.toggle()
                
                if state.isTimerOn {
                    return .run { send in
                        while true {
                            try await Task.sleep(for: .seconds(1))
                            await send(.timerTicked)
                        }
                    }
                    .cancellable(id: CancelID.timer)
                } else {
                    return .cancel(id: CancelID.timer)
                }
                
            case let .factResponse(fact):
                state.isLoadingFact = false
                state.factString = fact
                
                return .none
                
            case .timerTicked:
                state.number += 1
                
                return .none
            }
        }
    }
}

private extension CounterFeature {
    func decreaseNumber(num: inout Int) {
        num -= 1
    }
    
    enum CancelID {
        case timer
    }
}

struct ContentView: View {
    let store: Store<CounterFeature.State, CounterFeature.Action>
    let storeOf: StoreOf<CounterFeature>?
    
    var body: some View {
        WithViewStore(
            self.store,
            observe: { $0 }
        ) { viewStore in
            Form {
                Section {
                    Text("\(viewStore.number)")
                    Button("Decrement") {
                        viewStore.send(.decrementButtonTapped)
                    }
                    Button("Increment") {
                        viewStore.send(.incrementButtonTapped)
                    }
                }
                
                Section {
                    HStack {
                        Button("Get fact") {
                            viewStore.send(.getFactButtonTapped)
                        }
                        if viewStore.isLoadingFact {
                            Spacer()
                            ProgressView()
                        }
                    }
                    if let fact = viewStore.factString {
                        Text(fact)
                    }
                }
                
                Section {
                    Button(viewStore.isTimerOn ? "Stop Timer" : "Start Timer") {
                        viewStore.send(.toggleTimerButtonTapped)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView(
        store: Store(initialState: CounterFeature.State()) {
            CounterFeature()
                ._printChanges()
        }, storeOf: nil)
}
