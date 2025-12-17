import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var store: AppStore
    @State private var showingContactActionSheet = false
    @State private var showingDeleteAlert = false
    @State private var showingLoginSheet = false
    
    var body: some View {
        NavigationView {
            List {
                // Header / User Status
                Section {
                    HStack(spacing: 20) {
                        Image(systemName: store.isLoggedIn ? (store.currentUser?.avatarName ?? "person.crop.circle.fill") : "person.crop.circle")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.orange)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            if store.isLoggedIn {
                                Text(store.currentUser?.username ?? "User")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text(store.currentUser?.email ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Guest")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Button(action: { showingLoginSheet = true }) {
                                    Text("Tap to Login")
                                        .font(.subheadline)
                                        .foregroundColor(.orange)
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 10)
                }
                
                // Account Actions
                Section(header: Text("Account")) {
                    
                    NavigationLink(destination: PrivacyPolicyView()) {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }
                    
                    NavigationLink(destination: ContactView()) {
                        Label("Contact Support", systemImage: "phone")
                            .foregroundColor(.primary)
                    }
                }
                
                // Danger Zone / Auth
                Section {
                    if store.isLoggedIn {
                        VStack(spacing: 0) {
                            Button(action: store.logout) {
                                Text("Logout")
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 14)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Divider()
                            
                            Button(action: { showingDeleteAlert = true }) {
                                Text("Delete Account")
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 14)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .listRowInsets(EdgeInsets()) // Removes default row padding to allow full-width divider
                        .background(Color.white)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Profile")
            .sheet(isPresented: $showingLoginSheet) {
                LoginView()
            }
            .actionSheet(isPresented: $showingContactActionSheet) {
                ActionSheet(title: Text("Contact Support"), message: Text("Choose a method"), buttons: [
                    .default(Text("Send Email (zscbxbeueu@163.com)")) {
                        // Email action (simulated)
                        print("Email tapped")
                    },
                    .default(Text("Call Hotline (+1 800-888-8888)")) {
                        // Phone action (simulated)
                         if let url = URL(string: "tel://18008888888") {
                            UIApplication.shared.open(url)
                        }
                    },
                    .cancel(Text("Cancel"))
                ])
            }
            .actionSheet(isPresented: $showingDeleteAlert) {
                ActionSheet(title: Text("Delete Account"), message: Text("Are you sure? This cannot be undone."), buttons: [
                    .destructive(Text("Delete")) {
                        store.logout()
                    },
                    .cancel(Text("Cancel"))
                ])
            }
        }
    }
}

struct LoginView: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var email = ""
    @State private var code = ""
    @State private var showError = false
    
    // Timer State
    @State private var timeRemaining = 0
    @State private var timer: Timer? = nil
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Login via Email")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(spacing: 15) {
                TextField("Enter Email", text: $email)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                HStack {
                    TextField("Verification Code", text: $code)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .keyboardType(.numberPad)
                    
                    Button(action: sendCode) {
                        Text(timeRemaining > 0 ? "Resend in \(timeRemaining)s" : "Send Code")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(timeRemaining > 0 ? Color.gray : Color.orange)
                            .cornerRadius(8)
                    }
                    .disabled(timeRemaining > 0 || email.isEmpty)
                }
                
                // Test Account Hint
                HStack {
                    Image(systemName: "info.circle")
                    Text("Test Code: 888888")
                }
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 5)
            }
            .padding(.horizontal)
            
            if showError {
                Text("Invalid Code")
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button(action: {
                if store.login(email: email, code: code) {
                    presentationMode.wrappedValue.dismiss()
                } else {
                    showError = true
                }
            }) {
                Text("Login")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top, 50)
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    func sendCode() {
        guard !email.isEmpty else { return }
        // Start Timer
        timeRemaining = 60
        store.sendVerificationCode(email: email)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
            }
        }
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        WebView(urlString: "https://www.privacypolicies.com/live/82e875e3-3f80-4145-9c8e-55706aa68b72")
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
    }
}
