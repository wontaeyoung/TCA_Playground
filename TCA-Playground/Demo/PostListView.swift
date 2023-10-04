import ComposableArchitecture
import SwiftUI

let loginAuthor: Author = .init(name: "카즈")

struct PostFeature: Reducer {
    struct State: Equatable {
        var posts: IdentifiedArrayOf<Post> = []
    }
    
    enum Action: Equatable {
        case addButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                addPost(createPost(author: loginAuthor), posts: &state.posts)
                
                return .none
            }
        }
    }
}

private extension PostFeature {
    func createPost(author: Author) -> Post {
        return Post(author: author)
    }
    
    func addPost(_ post: Post, posts: inout IdentifiedArrayOf<Post>) {
        posts.append(post)
    }
}
