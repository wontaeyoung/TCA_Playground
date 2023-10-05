import ComposableArchitecture
import SwiftUI

struct PostDetailFeature: Reducer {
    struct State: Equatable {
        var post: Post
    }
    
    enum Action: Equatable {
        case saveButtonTapped(Post)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .saveButtonTapped:
                
                return .none
            }
        }
    }
}

struct PostDetailView: View {
    let store: StoreOf<PostDetailFeature>
    
    var body: some View {
        WithViewStore(
            self.store,
            observe: { $0 }
        ) { viewStore in
            VStack {
                Text(viewStore.post.title)
                    .font(.largeTitle)
                    .bold()
                
                Text(viewStore.post.content)
                    .font(.title3)
                
                Button {
                    viewStore.send(.saveButtonTapped(viewStore.post))
                } label: {
                    Text("저장하기")
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            .padding(.horizontal, 20)
        }
    }
}
