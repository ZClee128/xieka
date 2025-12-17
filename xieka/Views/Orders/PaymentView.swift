import SwiftUI
import CoreImage.CIFilterBuiltins

struct PaymentView: View {
    let order: Order
    @EnvironmentObject var store: AppStore
    @Environment(\.presentationMode) var presentationMode
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            // Scale up the image to avoid blur
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledImage = outputImage.transformed(by: transform)
            
            if let cgimg = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Pending Payment")
                .font(.headline)
            
            Text("¥\(Int(order.totalAmount))")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.black)
            
            // Generated QR Code
            Image(uiImage: generateQRCode(from: order.id.uuidString))
                .resizable()
                .interpolation(.none)
                .scaledToFit()
                .frame(width: 250, height: 250)
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            
            Text("Please scan QR code to pay")
                .foregroundColor(.secondary)
            
            Spacer().frame(height: 20)
            
            Text("Order ID: \(order.id.uuidString)")
                 .font(.caption2)
                 .foregroundColor(.gray)
                 .multilineTextAlignment(.center)
                 .padding(.horizontal)
                 .lineLimit(1)
                 .truncationMode(.middle)
        }
        .padding()
        .navigationBarTitle("Cashier", displayMode: .inline)
    }
}
