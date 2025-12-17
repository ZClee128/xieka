import SwiftUI

struct OrderListView: View {
    @EnvironmentObject var store: AppStore
    @State private var selectedStatus: String = "All"
    
    let statuses = ["All", "Pending", "Paid", "Shipped", "Completed"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Custom Segment Control
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(statuses, id: \.self) { status in
                                StatusPill(title: status, isSelected: selectedStatus == status) {
                                    withAnimation {
                                        selectedStatus = status
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                    .background(Color.white)
                    
                    if filteredOrders.isEmpty {
                        EmptyOrderView()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(filteredOrders) { order in
                                    OrderCard(order: order)
                                }
                            }
                            .padding(16)
                        }
                    }
                }
            }
            .navigationTitle("My Orders")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    var filteredOrders: [Order] {
        if selectedStatus == "All" {
            return store.orders
        }
        // Map English UI status back to rawValue or update OrderStatus rawValues (better approach)
        // Since OrderStatus rawValues are likely still Chinese or lowercased English, we need to check Order.swift
        // Ideally, OrderStatus should be updated to English raw values. 
        // For now, let's assume we update OrderStatus in Order.swift or map it here.
        // CHECK: Order.swift might need update.
        return store.orders.filter { $0.status.rawValue.capitalized == selectedStatus || $0.status.rawValue == selectedStatus }
    }
}

struct StatusPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .bold : .medium))
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(isSelected ? Color.orange : Color.gray.opacity(0.1))
                .foregroundColor(isSelected ? .white : .gray)
                .cornerRadius(20)
        }
    }
}

struct OrderCard: View {
    let order: Order
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Order #: \(order.id.uuidString.prefix(8))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(order.status.rawValue.capitalized) // Translate status display
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor.opacity(0.1))
                    .foregroundColor(statusColor)
                    .cornerRadius(4)
            }
            .padding(12)
            .background(Color.gray.opacity(0.05))
            
            Divider()
            
            // Content
            VStack(alignment: .leading, spacing: 12) {
                if order.items.count == 1, let item = order.items.first {
                    // Single Item View
                    HStack(spacing: 12) {
                        Image(item.product.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .cornerRadius(8)
                            .clipped()
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.product.name)
                                .font(.headline)
                                .lineLimit(2)
                            Text("¥\(Int(item.product.price))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text("x\(item.quantity)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                } else {
                    // Multiple Items Scroll
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(order.items) { item in
                                Image(item.product.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 70, height: 70)
                                    .cornerRadius(8)
                                    .clipped()
                            }
                        }
                    }
                }
            }
            .padding(12)
            
            Divider()
            
            // Footer
            HStack {
                Text(order.dateString)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text("\(order.items.reduce(0) { $0 + $1.quantity }) Items")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Total:")
                        .font(.caption)
                    Text("¥\(Int(order.totalAmount))")
                        .font(.headline)
                        .fontWeight(.bold)
                }
            }
            .padding(12)
            
            // Action Button (Only for Pending)
            if order.status == .pending {
                Divider()
                NavigationLink(destination: PaymentView(order: order)) {
                    Text("Pay Now")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.red)
                }
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    var statusColor: Color {
        switch order.status {
        case .pending: return .red
        case .paid: return .green
        case .shipped: return .orange
        case .completed: return .blue
        case .cancelled: return .gray
        }
    }
}

struct EmptyOrderView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.gray.opacity(0.5))
            Text("No orders found")
                .foregroundColor(.secondary)
            Spacer()
        }
    }
}
