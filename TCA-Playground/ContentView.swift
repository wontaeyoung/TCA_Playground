import ComposableArchitecture
import SwiftUI

struct CounterFeature: Reducer {
    struct State {
        var number: Int = 0
        var factString: String? = nil
        var isTimerOn: Bool = false
    }
    
    enum Action {
        case incrementButtonTapped
        case decrementButtonTapped
        case getFactButtonTapped
        case toggleTimerButtonTapped
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
                return .none
                
            case .toggleTimerButtonTapped:
                state.isTimerOn.toggle()
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
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
