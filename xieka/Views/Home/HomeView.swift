import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: AppStore
    @State private var selectedCategory: String = "All"
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    let categories = ["All", "Selected", "Family", "Gift", "New"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Section
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Welcome Back")
                                .font(isRegularLayout ? .title3 : .subheadline)
                                .foregroundColor(.gray)
                            Text("Crab Gift Market")
                                .font(isRegularLayout ? .system(size: 36, weight: .bold) : .largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.orange, .red],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        }
                        Spacer(minLength: isRegularLayout ? 40 : 0)
                    }
                    .padding(.horizontal, isRegularLayout ? 40 : 16)
                    .padding(.top)
                    
                    // Hero Section / Featured
                    if let featuredProduct = store.products.first(where: { $0.name == "Golden King Crab" }) {
                        NavigationLink(destination: ProductDetailView(product: featuredProduct)) {
                            FeaturedCardView()
                                .frame(height: isRegularLayout ? 300 : 220)
                                .frame(maxWidth: isRegularLayout ? 720 : .infinity)
                                .padding(.horizontal, isRegularLayout ? 40 : 16)
                                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                        }
                    }
                    
                    // Categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: isRegularLayout ? 18 : 15) {
                            ForEach(categories, id: \.self) { category in
                                CategoryPill(title: category, isSelected: selectedCategory == category) {
                                    withAnimation {
                                        selectedCategory = category
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, isRegularLayout ? 40 : 16)
                    }
                    
                    // Product Grid
                    LazyVGrid(columns: gridColumns, spacing: isRegularLayout ? 24 : 20) {
                        ForEach(filteredProducts, id: \.id) { product in
                            NavigationLink(destination: ProductDetailView(product: product)) {
                                ProductCardView(product: product)
                            }
                        }
                    }
                    .padding(.horizontal, isRegularLayout ? 40 : 16)
                    .frame(maxWidth: isRegularLayout ? 900 : .infinity, alignment: .center)
                    .padding(.bottom, 80) // Space for tab bar
                }
            }
            .navigationBarHidden(true)
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
    
    var filteredProducts: [Product] {
        if selectedCategory == "All" {
            return store.products
        }
        return store.products.filter { $0.tags.contains(selectedCategory) }
    }
    
    private var isRegularLayout: Bool {
        horizontalSizeClass == .regular
    }
    
    private var gridColumns: [GridItem] {
        if isRegularLayout {
            // On iPad use 3 responsive columns to avoid crowding and huge cards
            return Array(repeating: GridItem(.flexible(minimum: 220), spacing: 32), count: 3)
        } else {
            return [GridItem(.flexible()), GridItem(.flexible())]
        }
    }
}

// MARK: - Subviews

struct FeaturedCardView: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image("黄金帝王蟹")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 220)
                .clipped()
                .overlay(Color.black.opacity(0.3)) // Improve text readability
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Limited Edition")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(6)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(4)
                
                Text("Golden King Crab")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("The ultimate gift of the season.")
                    .font(.subheadline)
                    .lineLimit(2)
            }
            .padding()
            .foregroundColor(.white)
        }
        .cornerRadius(20)
    }
}

struct CategoryPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    private var isRegularLayout: Bool {
        horizontalSizeClass == .regular
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(isRegularLayout ? .title3 : .body)
                .fontWeight(.medium)
                .padding(.vertical, isRegularLayout ? 14 : 10)
                .padding(.horizontal, isRegularLayout ? 28 : 20)
                .background(isSelected ? Color.orange : Color.white)
                .foregroundColor(isSelected ? .white : .gray)
                .cornerRadius(25)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
        }
    }
}

struct ProductCardView: View {
    let product: Product
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    private var isRegularLayout: Bool {
        horizontalSizeClass == .regular
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // Image Placeholder
            ZStack {
                Image(product.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: isRegularLayout ? 160 : 120)
                    .clipped()
            }
            .frame(height: isRegularLayout ? 160 : 120)
            .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: isRegularLayout ? 10 : 4) {
                Text(product.name)
                    .font(isRegularLayout ? .title3 : .headline)
                    .lineLimit(1)
                    .foregroundColor(.primary)
                
                Text(product.description)
                    .font(isRegularLayout ? .body : .caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Text("¥\(Int(product.price))")
                        .font(isRegularLayout ? .title2 : .title3)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    
                    Spacer()
                    
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                }
                .padding(.top, 4)
            }
            .padding(12)
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
