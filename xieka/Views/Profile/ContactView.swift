import SwiftUI

struct ContactView: View {
    var body: some View {
        List {
            Section(header: Text("Contact Info")) {
                Button(action: {
                    // Action: Copy Email
                    UIPasteboard.general.string = "zscbxbeueu@163.com"
                }) {
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.blue)
                            .frame(width: 25)
                        Text("Send Email")
                        Spacer()
                        Text("zscbxbeueu@163.com")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                }
                
                Button(action: {
                    // Action: Call Phone
                    if let url = URL(string: "tel://12135550199") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.green)
                            .frame(width: 25)
                        Text("Support Hotline")
                        Spacer()
                        Text("+1 (213) 555-0199")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                }
            }
            
            Section(header: Text("Service Hours")) {
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.orange)
                        .frame(width: 25)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Mon-Fri: 9:00 - 18:00 (PST)")
                        Text("Sat-Sun: 10:00 - 16:00 (PST)")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
            }
            
            Section(footer: Text("Tap item to copy email or call.")) {
                EmptyView()
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Contact Support")
    }
}
