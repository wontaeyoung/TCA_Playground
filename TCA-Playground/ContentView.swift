import ComposableArchitecture
import SwiftUI

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
