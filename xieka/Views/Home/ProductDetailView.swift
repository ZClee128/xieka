import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @EnvironmentObject var store: AppStore
    @Environment(\.presentationMode) var presentationMode

    @State private var currentOrder: Order?
    @State private var showingLoginSheet = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Image Section
                    ZStack {
                        Image(product.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 300)
                            .clipped()
                            .foregroundColor(.orange)
                    }
                    .frame(height: 300)
                    .edgesIgnoringSafeArea(.top)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        // Title and Tags
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                ForEach(product.tags, id: \.self) { tag in
                                    Text(tag)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(Color.orange.opacity(0.1))
                                        .foregroundColor(.orange)
                                        .cornerRadius(8)
                                }
                            }
                            
                            Text(product.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        
                        Divider()
                        
                        // Description
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Product Details")
                                .font(.headline)
                            Text(product.description)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineSpacing(4)
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                    .offset(y: -30)
                }
            }
            
            // Bottom Action Bar
            HStack {
                VStack(alignment: .leading) {
                    Text("Total")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("¥\(Int(product.price))")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                }
                
                Spacer()
                
                Button(action: {
                    if !store.isLoggedIn {
                        showingLoginSheet = true
                        return
                    }
                    store.addToCart(product: product)
                    // Optional: Show some feedback or dismiss
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add to Cart")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .cornerRadius(15)
                        .shadow(color: .orange.opacity(0.4), radius: 10, x: 0, y: 5)
                }
                
                Button(action: {
                    if !store.isLoggedIn {
                        showingLoginSheet = true
                        return
                    }
                    currentOrder = store.buyNow(product: product)
                }) {
                    Text("Buy Now")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(15)
                        .shadow(color: .red.opacity(0.4), radius: 10, x: 0, y: 5)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 40) // Adjust for safe area
            .padding(.top, 20)
            .background(Color.white)
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: -5)
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left.circle.fill")
                .font(.title)
                .foregroundColor(.white)
                .shadow(radius: 4)
        })
        .sheet(item: $currentOrder) { order in
            PaymentView(order: order)
        }
        .sheet(isPresented: $showingLoginSheet) {
            LoginView()
        }
    }
}

// Extension for partial rounded corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
