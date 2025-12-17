import SwiftUI

class AppStore: ObservableObject {
    @Published var products: [Product] = []
    @Published var cartItems: [CartItem] = []
    @Published var orders: [Order] = []
    @Published var currentUser: User? = nil
    @Published var isLoggedIn: Bool = false
    
    // Data Persistence (Mock)
    private var userCarts: [String: [CartItem]] = [:]
    private var userOrders: [String: [Order]] = [:]
    
    init() {
        self.products = Product.mockProducts()
        restoreSession()
    }
    
    // MARK: - Cart Logic
    func addToCart(product: Product, quantity: Int = 1) {
        // Ensure user is logged in (View should handle checking this too to show UI)
        guard isLoggedIn else { return }
        
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems[index].quantity += quantity
        } else {
            let newItem = CartItem(id: UUID(), product: product, quantity: quantity)
            cartItems.append(newItem)
        }
        saveUserData()
    }
    
    func removeFromCart(offsets: IndexSet) {
        cartItems.remove(atOffsets: offsets)
        saveUserData()
    }
    
    func updateQuantity(item: CartItem, newQuantity: Int) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            cartItems[index].quantity = newQuantity
            saveUserData()
        }
    }
    
    var cartTotal: Double {
        cartItems.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }
    
    // MARK: - Order Logic
    func createOrder(from itemsToOrder: [CartItem] = []) -> Order? {
        guard isLoggedIn else { return nil }
        
        // If no specific items passed, assume all (fallback) or guard
        let items = itemsToOrder.isEmpty ? cartItems : itemsToOrder
        guard !items.isEmpty else { return nil }
        
        // Create Order
        let newOrder = Order(id: UUID(), items: items, totalAmount: items.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }, status: .pending, date: Date())
        orders.insert(newOrder, at: 0)
        
        // Remove ordered items from cart
        let orderedIds = items.map { $0.id }
        cartItems.removeAll { orderedIds.contains($0.id) }
        
        saveUserData()
        return newOrder
    }
    
    func buyNow(product: Product) -> Order? {
        guard isLoggedIn else { return nil }
        
        let item = CartItem(id: UUID(), product: product, quantity: 1)
        let newOrder = Order(id: UUID(), items: [item], totalAmount: product.price, status: .pending, date: Date())
        orders.insert(newOrder, at: 0)
        
        saveUserData()
        return newOrder
    }
    
    func payOrder(orderId: UUID) {
        if let index = orders.firstIndex(where: { $0.id == orderId }) {
            orders[index].status = .paid
            saveUserData()
        }
    }
    
    // MARK: - Auth Logic
    // MARK: - Auth Logic
    func sendVerificationCode(email: String) -> Bool {
        // Mock sending code
        print("Sending verification code to \(email)")
        return true
    }
    
    func login(email: String, code: String) -> Bool {
        // Mock Auth Check
        // Allow any email with code "888888" or the test account
        if (code == "888888" && email == "test@crabgift.com") {
            // Success
             let user = User(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!, username: "Crab Gift Expert 88", avatarName: "person.crop.circle.fill", email: email)
            currentUser = user
            isLoggedIn = true
            
            // Persist Login State
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            if let encodedUser = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(encodedUser, forKey: "currentUser")
            }
            
            loadUserData()
            return true
        }
        return false
    }
    
    func logout() {
        saveUserData()
        isLoggedIn = false
        currentUser = nil
        cartItems = []
        orders = []
        
        // Clear Persistence
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "currentUser")
    }
    
    // MARK: - Persistence Helpers
    private func saveUserData() {
        guard let user = currentUser else { return }
        userCarts[user.id.uuidString] = cartItems
        userOrders[user.id.uuidString] = orders
        
        // Persist Mock Data to UserDefaults (for demo purposes)
        if let encodedCarts = try? JSONEncoder().encode(userCarts) {
            UserDefaults.standard.set(encodedCarts, forKey: "userCarts")
        }
        if let encodedOrders = try? JSONEncoder().encode(userOrders) {
            UserDefaults.standard.set(encodedOrders, forKey: "userOrders")
        }
    }
    
    private func loadUserData() {
        guard let user = currentUser else { return }
        cartItems = userCarts[user.id.uuidString] ?? []
        orders = userOrders[user.id.uuidString] ?? []
    }
    
    // Check for existing session
    private func restoreSession() {
        print("Restoring session...")
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        if isLoggedIn, let savedUserData = UserDefaults.standard.data(forKey: "currentUser") {
            do {
                let user = try JSONDecoder().decode(User.self, from: savedUserData)
                self.currentUser = user
                self.isLoggedIn = true
                print("User session restored: \(user.username)")
                
                // Restore Mock Data
                if let savedCartsData = UserDefaults.standard.data(forKey: "userCarts") {
                    do {
                        let savedCarts = try JSONDecoder().decode([String: [CartItem]].self, from: savedCartsData)
                        self.userCarts = savedCarts
                        print("User carts restored: \(savedCarts.keys.count) users")
                        // If current user has cart data in the restored dictionary, ensure it loads
                        if let userItems = savedCarts[user.id.uuidString] {
                            print("Current user has \(userItems.count) items in cart")
                        } else {
                            print("Current user has no saved cart items")
                        }
                    } catch {
                        print("Failed to decode userCarts: \(error)")
                    }
                }
                
                if let savedOrdersData = UserDefaults.standard.data(forKey: "userOrders") {
                    do {
                        let savedOrders = try JSONDecoder().decode([String: [Order]].self, from: savedOrdersData)
                        self.userOrders = savedOrders
                         print("User orders restored")
                    } catch {
                        print("Failed to decode userOrders: \(error)")
                    }
                }
                
                loadUserData()
            } catch {
                print("Failed to decode user: \(error)")
                // Fallback: Clear invalid session
                logout()
            }
        }
    }
}
