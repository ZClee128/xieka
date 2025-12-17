import Foundation

struct CartItem: Identifiable, Codable, Hashable {
    let id: UUID
    let product: Product
    var quantity: Int
}
