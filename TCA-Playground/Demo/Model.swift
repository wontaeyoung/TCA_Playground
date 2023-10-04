import Foundation

struct Post: Identifiable, Equatable, Codable {
    let id: UUID
    let author: Author
    let title: String
    let content: String
    let createdAt: Date
    
    init(author: Author) {
        self.id = UUID()
        self.author = author
        self.title = ""
        self.content = ""
        self.createdAt = Date.now
    }
}

struct Author: Identifiable, Equatable, Codable {
    let id: UUID
    let name: String
}
