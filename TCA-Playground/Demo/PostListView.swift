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
        var posts: IdentifiedArrayOf<Post> = [Post(author: loginAuthor)]
        var alertState: AlertState = .init()
    }
    
    enum Action: Equatable {
        case addButtonTapped
        case showingAlert(title: String, message: String)
        case postDetailAction(PostDetailFeature.Action)
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
                
                // MARK: - DetailFeature 처리
            case let .postDetailAction(.saveButtonTapped(updatedPost)):
                print("출력! \n", updatedPost.title)
                state.posts[id: updatedPost.id] = updatedPost
                
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

struct PostListView: View {
    let store: StoreOf<PostFeature> = .init(
        initialState: PostFeature.State()
    ) {
        PostFeature()
    }
    
    var body: some View {
        WithViewStore(
            self.store,
            observe: { $0 }
        ) { viewStore in
            NavigationStack {
                List {
                    ForEach(viewStore.posts) { post in
                        NavigationLink {
                            PostDetailView(
                                store: store.scope { _ in
                                    PostDetailFeature.State(post: post)
                                } action: { childAction in
                                    .postDetailAction(childAction)
                                }
                            )
                        } label: {
                            Text(post.title)
                        }
                    }
                }
            }
        }
    }
}
