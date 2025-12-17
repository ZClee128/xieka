import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            CartView()
                .badge(store.cartItems.reduce(0) { $0 + $1.quantity })
                .tabItem {
                    Label("Cart", systemImage: "cart.fill")
                }
            
            OrderListView()
                .tabItem {
                    Label("Orders", systemImage: "list.bullet.rectangle.portrait.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .accentColor(.orange) // Crab theme color?
    }
}
