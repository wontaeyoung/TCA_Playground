import ComposableArchitecture
import SwiftUI

let loginAuthor: Author = .init(name: "카즈")

struct AlertState: Equatable {
    var isShowing: Bool = false
    var title: String = ""
    var message: String = ""
}

struct PostFeature: Reducer {
    struct State: Equatable {
        var posts: IdentifiedArrayOf<Post> = []
        var alertState: AlertState = .init()
    }
    
    enum Action: Equatable {
        case addButtonTapped
        
        case showingAlert(title: String, message: String)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                addPost(createPost(author: loginAuthor), posts: &state.posts)
                
                return .send(
                    .showingAlert(
                        title: "게시글 등록",
                        message: "게시글 등록이 완료되었습니다!"
                    )
                )
                
            case let .showingAlert(title, message):
                showAlert(
                    alertState: &state.alertState,
                    title: title,
                    message: message)
                
                
                return .none
            }
        }
    }
}

private extension PostFeature {
    func createPost(author: Author) -> Post {
        return Post(author: author)
    }
    
    func addPost(
        _ post: Post,
        posts: inout IdentifiedArrayOf<Post>
    ) {
        posts.append(post)
    }
    
    func showAlert(
        alertState: inout AlertState,
        title: String,
        message: String
    ) {
        alertState.title = title
        alertState.message = message
        alertState.isShowing = true
    }
}
