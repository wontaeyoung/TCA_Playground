import ComposableArchitecture
import SwiftUI

struct CounterFeature: Reducer {
    struct State: Equatable {
        var number: Int = 0
        var factString: String? = nil
        var isTimerOn: Bool = false
    }
    
    enum Action {
        case incrementButtonTapped
        case decrementButtonTapped
        case getFactButtonTapped
        case toggleTimerButtonTapped
        
        case factResponse(fact: String)
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
                return .run { [someNumber = state.number] send in
                    let (data, _) = try await URLSession.shared.data(
                        from: URL(string: "http://www.numbersapi.com/\(someNumber)")!
                    )
                    let numberFact: String = .init(decoding: data, as: UTF8.self)
                    
                    await send(.factResponse(fact: numberFact))
                }
                
            case .toggleTimerButtonTapped:
                state.isTimerOn.toggle()
                return .none
                
            case let .factResponse(fact):
                state.factString = fact
                return .none
            }
        }
    }
}

private extension CounterFeature {
    func decreaseNumber(num: inout Int) {
        num -= 1
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
                    Button("Get fact") {
                        viewStore.send(.getFactButtonTapped)
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
