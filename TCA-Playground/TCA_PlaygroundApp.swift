import ComposableArchitecture
import SwiftUI

@main
struct TCA_PlaygroundApp: App {
    var body: some Scene {
        WindowGroup {
            TourView(
                store: Store(initialState: CounterFeature.State()) {
                    CounterFeature()
                }, storeOf: nil
            )
        }
    }
}
