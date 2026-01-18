//
//  AuthView.swift
//  GlassCast
//
//  Created by Amrit Raj on 18/01/26.
//
import SwiftUI

struct AuthView: View {

    @EnvironmentObject var authService: AuthService

    @State private var email = ""
    @State private var password = ""
    @State private var isLogin = true
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 24) {

            Text(isLogin ? "Login" : "Create Account")
                .font(.largeTitle.bold())

            VStack(spacing: 16) {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textFieldStyle(.roundedBorder)

                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
            }

            if let error = authService.authError {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            Button {
                Task {
                    isLoading = true
                    if isLogin {
                        await authService.signIn(email: email, password: password)
                    } else {
                        await authService.signUp(email: email, password: password)
                    }
                    isLoading = false
                }
            } label: {
                if isLoading {
                    ProgressView()
                } else {
                    Text(isLogin ? "Login" : "Sign Up")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(email.isEmpty || password.isEmpty)

            Button {
                isLogin.toggle()
                authService.authError = nil
            } label: {
                Text(isLogin
                     ? "Don't have an account? Sign Up"
                     : "Already have an account? Login")
                    .font(.footnote)
            }

            Spacer()
        }
        .padding()
    }
}
#Preview {
    AuthView()
        .environmentObject(AuthService())
}
