import SwiftUI
import AuthenticationServices

struct SignupView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    @State private var errorMessage: String? = nil
    @State private var isLoading: Bool = false
    @State private var didRegister: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.black, Color(red: 0/255, green: 0/255, blue: 60/255)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 30) {
                    // Title
                    Text("Create account")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .shadow(color: Color.blue.opacity(0.6), radius: 10, x: 0, y: 0)

                    // Fields
                    VStack(spacing: 20) {
                        TextField("Email", text: $email, prompt:
                                    Text("Email")
                            .foregroundStyle(.white.opacity(0.8)))
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .keyboardType(.emailAddress)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(red: 0/255, green: 0/255, blue: 60/255))
                            .cornerRadius(12)

                        SecureField("Password", text: $password,
                                    prompt:
                                        Text("Password")
                                .foregroundStyle(.white.opacity(0.8)))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(red: 0/255, green: 0/255, blue: 60/255))
                            .cornerRadius(12)

                        SecureField("Confirm Password", text: $confirmPassword,
                                    prompt:
                                        Text("Confirm Password")
                                .foregroundStyle(.white.opacity(0.8)))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(red: 0/255, green: 0/255, blue: 60/255))
                            .cornerRadius(12)
                        
                        if let errorMessage {
                            Text(errorMessage)
                                .font(.footnote)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .font(.headline)

                    // Sign Up Button
                    Button {
                        // Clear previous error
                        errorMessage = nil

                        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
                        let isValidEmail = NSPredicate(format: "SELF MATCHES[c] %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: trimmedEmail)

                        guard !trimmedEmail.isEmpty else {
                            errorMessage = "Please enter your email."
                            print("[SignUp] Missing email")
                            return
                        }

                        guard isValidEmail else {
                            errorMessage = "Please enter a valid email address."
                            print("[SignUp] Invalid email: \(trimmedEmail)")
                            return
                        }

                        guard !password.isEmpty else {
                            errorMessage = "Please enter your password."
                            print("[SignUp] Missing password")
                            return
                        }

                        guard password == confirmPassword else {
                            errorMessage = "Passwords do not match."
                            print("[SignUp] Passwords do not match")
                            return
                        }

                        print("[SignUp] Email: \(trimmedEmail)")
                        print("[SignUp] Password: \(password)")

                        isLoading = true
                        Task {
                            let success = await register(email: trimmedEmail, password: password)
                            await MainActor.run {
                                isLoading = false
                                if success {
                                    print("[SignUp] Registration succeeded for: \(trimmedEmail)")
                                    didRegister = true
                                } else {
                                    errorMessage = "Failed to create your account. Please try again."
                                    print("[SignUp] Registration failed for: \(trimmedEmail)")
                                }
                            }
                        }
                    } label: {
                        Text(isLoading ? "Signing Up…" : "Sign Up")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                            .foregroundColor(.white)
                    }
                    .accessibilityLabel("Sign Up with Email and Password")

                    // Divider with or
                    HStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.white.opacity(0.3))
                        Text("or")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.subheadline)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.white.opacity(0.3))
                    }
                    .padding(.horizontal)

                    // SSO Buttons
                    VStack(spacing: 16) {
                        SignInWithAppleButton(.signUp) { request in
                            // configuration for Sign in with Apple request (if any)
                            request.requestedScopes = [.email, .fullName]
                        } onCompletion: { result in
                            // handle result (for now do nothing)
                        }
                        .signInWithAppleButtonStyle(.white)
                        .frame(height: 45)
                        .cornerRadius(12)
                        .accessibilityLabel("Sign Up with Apple")

                        Button {
                            print("Sign Up with Google tapped")
                        } label: {
                            HStack {
                                Image(systemName: "g.circle.fill")
                                    .font(.title2)
                                Text("Sign Up with Google")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0/255, green: 0/255, blue: 60/255))
                            .cornerRadius(12)
                        }
                        .accessibilityLabel("Sign Up with Google")
                    }
                    .padding(.horizontal)

                    Spacer()

                    // Footer
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(.white.opacity(0.7))
                        NavigationLink("Log in", destination: LoginView())
                            .foregroundColor(Color.blue)
                            .fontWeight(.semibold)
                    }
                    .font(.footnote)
                }
                .padding()
            }
            .navigationDestination(isPresented: $didRegister) {
                WelcomeView()
            }
        }
    }
    
    // MARK: - Registration
    private func register(email: String, password: String) async -> Bool {
        // Simulate network latency
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        // TODO: Replace with real API/database request to create the user
        // For demo: succeed when password length is at least 8
        return !email.isEmpty && password.count >= 8
    }
}

#Preview {
    SignupView()
}
