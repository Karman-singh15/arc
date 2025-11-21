import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var errorMessage: String? = nil
    @State private var isLoading: Bool = false
    @State private var isAuthenticated: Bool = false
    
    private let darkBlue = Color(red: 0.05, green: 0.08, blue: 0.2)
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.black, darkBlue]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("arc")
                            .font(.system(size: 96, weight: .bold, design: .default))
                            .foregroundColor(.blue)
                            .shadow(color: Color.blue.opacity(0.6), radius: 10, x: 0, y: 0)
                        Text("Sign in to continue")
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    VStack(spacing: 16) {
                        SignInWithAppleButton(
                            .signIn,
                            onRequest: { _ in
                                // TODO: configure request
                            },
                            onCompletion: { _ in
                                // TODO: handle completion
                            }
                        )
                        .signInWithAppleButtonStyle(.whiteOutline)
                        .frame(height: 50)
                        .cornerRadius(12)
                        .accessibilityLabel("Sign in with Apple")
                        
                        Button {
                            // TODO: integrate GoogleSignIn SDK for Google login
                        } label: {
                            HStack {
                                Image(systemName: "g.circle.fill")
                                    .font(.title2)
                                Text("Continue with Google")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(darkBlue)
                            .cornerRadius(12)
                        }
                        .accessibilityLabel("Continue with Google")
                        
                        HStack(alignment: .center) {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color.white.opacity(0.2))
                            Text("or")
                                .foregroundColor(.white.opacity(0.5))
                                .fontWeight(.semibold)
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color.white.opacity(0.2))
                        }
                        
                        VStack(spacing: 16) {
                            TextField(
                                "Email",
                                text: $email,
                                prompt: Text("Email").foregroundStyle(.white.opacity(0.8))
                            )
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding()
                            .background(darkBlue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .textInputAutocapitalization(.never)
                            
                            SecureField(
                                "Password",
                                text: $password,
                                prompt: Text("Password").foregroundStyle(.white.opacity(0.8))
                            )
                            .padding()
                            .background(darkBlue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            
                            if let errorMessage {
                                Text(errorMessage)
                                    .font(.footnote)
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        
                        Button {
                            // Clear previous error
                            errorMessage = nil
                            
                            // Basic validation
                            guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                                errorMessage = "Please enter your email."
                                print("[SignIn] Missing email")
                                return
                            }
                            
                            guard !password.isEmpty else {
                                errorMessage = "Please enter your password."
                                print("[SignIn] Missing password")
                                return
                            }
                            
                            print("[SignIn] Email: \(email)")
                            print("[SignIn] Password: \(password)")
                            
                            // Simulate a network/database authentication
                            isLoading = true
                            Task {
                                let success = await authenticate(email: email, password: password)
                                await MainActor.run {
                                    isLoading = false
                                    if success {
                                        isAuthenticated = true
                                        print("[SignIn] Authentication succeeded for: \(email)")
                                    } else {
                                        errorMessage = "Invalid email or password."
                                        print("[SignIn] Authentication failed for: \(email)")
                                    }
                                }
                            }
                        } label: {
                            Text(isLoading ? "Signing In…" : "Sign In")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .foregroundColor(.white)
                                .background(
                                    LinearGradient(
                                        colors: [Color.blue.opacity(0.9), Color.blue],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                        }
                        .accessibilityLabel("Sign In")
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    HStack {
                        Text("New here?")
                            .foregroundColor(.white.opacity(0.7))
                        NavigationLink(destination: SignupView()) {
                            Text("Create an account")
                                .foregroundColor(.blue)
                                .fontWeight(.semibold)
                        }
                    }
                }
                .padding(.top, 40)
                .padding(.bottom, 30)
                .padding(.horizontal, 24)
            }
        }
    }
    
    // MARK: - Authentication
    private func authenticate(email: String, password: String) async -> Bool {
        // Simulate network latency
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        // TODO: Replace with real API/database request
        // For demo: succeed when password equals "password123"
        return !email.isEmpty && password == "1234"
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
