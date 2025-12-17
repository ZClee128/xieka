import Foundation

enum OrderStatus: String, Codable, CaseIterable {
    case pending = "Pending"
    case paid = "Paid"
    case shipped = "Shipped"
    case completed = "Completed"
    case cancelled = "Cancelled"
}

struct Order: Identifiable, Codable {
    let id: UUID
    let items: [CartItem]
    let totalAmount: Double
    var status: OrderStatus
    let date: Date
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
