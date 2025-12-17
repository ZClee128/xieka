import SwiftUI

struct CartView: View {
    @EnvironmentObject var store: AppStore
    @State private var selectedItemIds: Set<UUID> = []
    @State private var isEditing = false
    @State private var currentOrder: Order?
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)
                
                if store.cartItems.isEmpty {
                    EmptyCartView()
                } else {
                    VStack(spacing: 0) {
                        List {
                            ForEach(store.cartItems) { item in
                                CartRow(item: item, isSelected: selectedItemIds.contains(item.id)) {
                                    toggleSelection(for: item)
                                } quantityAction: { newQuantity in
                                    store.updateQuantity(item: item, newQuantity: newQuantity)
                                }
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                                .listRowSeparator(.hidden)
                            }
                            .onDelete(perform: store.removeFromCart)
                        }
                        .listStyle(PlainListStyle())
                        .padding(.bottom, 100) // Space for bottom bar
                    }
                }
                
                // Bottom Checkout Bar
                if !store.cartItems.isEmpty {
                    VStack(spacing: 0) {
                        Divider()
                            .background(Color.gray.opacity(0.1))
                        
                        HStack {
                            // Select All
                            Button(action: toggleSelectAll) {
                                HStack(spacing: 8) {
                                    Image(systemName: allSelected ? "checkmark.circle.fill" : "circle")
                                        .font(.title2)
                                        .foregroundColor(allSelected ? .orange : .gray.opacity(0.5))
                                    Text("Select All")
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                }
                            }
                            
                            Spacer()
                            
                            // Total Price
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("Total")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("¥\(Int(totalSelectedPrice))")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.orange)
                            }
                            
                            // Checkout Button
                            Button(action: checkout) {
                                Text("Checkout (\(selectedItemIds.count))")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 24)
                                    .background(
                                        LinearGradient(gradient: Gradient(colors: selectedItemIds.isEmpty ? [.gray] : [.orange, .red]), startPoint: .leading, endPoint: .trailing)
                                    )
                                    .cornerRadius(25)
                                    .shadow(color: selectedItemIds.isEmpty ? .clear : .orange.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            .disabled(selectedItemIds.isEmpty)
                            .padding(.leading, 12)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 30) // Safe area
                        .background(Color.white)
                        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: -5)
                    }
                }
            }
            .navigationTitle("Cart")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                EditButton()
            }
            .sheet(item: $currentOrder) { order in
                PaymentView(order: order)
            }
        }
    }
    
    // Logic
    var allSelected: Bool {
        !store.cartItems.isEmpty && selectedItemIds.count == store.cartItems.count
    }
    
    var totalSelectedPrice: Double {
        store.cartItems
            .filter { selectedItemIds.contains($0.id) }
            .reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }
    
    func toggleSelection(for item: CartItem) {
        if selectedItemIds.contains(item.id) {
            selectedItemIds.remove(item.id)
        } else {
            selectedItemIds.insert(item.id)
        }
    }
    
    func toggleSelectAll() {
        if allSelected {
            selectedItemIds.removeAll()
        } else {
            selectedItemIds = Set(store.cartItems.map { $0.id })
        }
    }
    
    func checkout() {
        let itemsToOrder = store.cartItems.filter { selectedItemIds.contains($0.id) }
        guard !itemsToOrder.isEmpty else { return }
        
        if let order = store.createOrder(from: itemsToOrder) {
            currentOrder = order
            selectedItemIds.removeAll()
        }
    }
}

struct CartRow: View {
    let item: CartItem
    let isSelected: Bool
    let selectionAction: () -> Void
    let quantityAction: (Int) -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Checkbox
            Button(action: selectionAction) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isSelected ? .orange : .gray.opacity(0.3))
            }
            .buttonStyle(PlainButtonStyle())
            
            // Card Content
            HStack(spacing: 12) {
                // Image
                Image(item.product.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(12)
                    .clipped()
                
                // Info
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.product.name)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    if let tag = item.product.tags.first {
                        Text(tag)
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.orange.opacity(0.1))
                            .foregroundColor(.orange)
                            .cornerRadius(4)
                    }
                    
                    HStack {
                        Text("¥\(Int(item.product.price))")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.red)
                        
                        Spacer()
                        
                        // Quantity Stepper
                        HStack(spacing: 0) {
                            Button(action: {
                                if item.quantity > 1 {
                                    quantityAction(item.quantity - 1)
                                }
                            }) {
                                Image(systemName: "minus")
                                    .font(.system(size: 12, weight: .bold))
                                    .frame(width: 28, height: 28)
                                    .background(Color.gray.opacity(0.1))
                                    .foregroundColor(.primary)
                            }
                            
                            Text("\(item.quantity)")
                                .font(.system(size: 14, weight: .medium))
                                .frame(width: 32, height: 28)
                                .background(Color.gray.opacity(0.1))
                            
                            Button(action: {
                                quantityAction(item.quantity + 1)
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 12, weight: .bold))
                                    .frame(width: 28, height: 28)
                                    .background(Color.gray.opacity(0.1))
                                    .foregroundColor(.primary)
                            }
                        }
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                        )
                    }
                }
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 2)
        }
    }
}

struct EmptyCartView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.1))
                    .frame(width: 120, height: 120)
                Image(systemName: "cart.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.orange)
            }
            
            VStack(spacing: 8) {
                Text("Your Cart is Empty")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Text("Go find some amazing crab gifts!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.bottom, 50)
    }
}
