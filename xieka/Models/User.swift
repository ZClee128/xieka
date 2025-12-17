import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    let username: String
    let avatarName: String
    let email: String
    
    static let mockUser = User(id: UUID(), username: "Crab Gift Expert 88", avatarName: "person.crop.circle.fill", email: "test@crabgift.com")
}
