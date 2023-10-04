import ComposableArchitecture

struct NumberFactClient {
    var fetch: @Sendable (Int) async throws -> String
}

extension NumberFactClient: DependencyKey {
    static let liveValue: NumberFactClient = .init(
        fetch: { number in
            try await Task.sleep(for: .seconds(1))
            let numberFact: String = number.description + " 응답 받았습니다."
            
            return numberFact
        }
    )
}
