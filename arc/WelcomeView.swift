import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, Color.blue.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(spacing: 16) {
                Text("Welcome")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                Text("Your account was created successfully.")
                    .foregroundColor(.white.opacity(0.8))
                Button {
                    // Dismiss or navigate further as needed
                } label: {
                    Text("Continue")
                        .fontWeight(.semibold)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

#Preview {
    WelcomeView()
}
