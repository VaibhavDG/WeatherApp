//
//  AuthService.swift
//  GlassCast
//
//  Created by Amrit Raj on 18/01/26.
//
import Foundation
import Supabase
import Combine

@MainActor
final class AuthService: ObservableObject {

    @Published var isAuthenticated: Bool = false
    @Published var authError: String?

    init() {
        Task {
            await checkSession()
        }
    }

    func signUp(email: String, password: String) async {
        do {
            try await supabase.auth.signUp(
                email: email,
                password: password
            )
            isAuthenticated = true
        } catch {
            authError = error.localizedDescription
        }
    }

    func signIn(email: String, password: String) async {
        do {
            try await supabase.auth.signIn(
                email: email,
                password: password
            )
            isAuthenticated = true
        } catch {
            authError = error.localizedDescription
        }
    }

    func signOut() async {
        do {
            try await supabase.auth.signOut()
            isAuthenticated = false
        } catch {
            authError = error.localizedDescription
        }
    }

    func checkSession() async {
        do {
            _ = try await supabase.auth.session
            isAuthenticated = true
        } catch {
            isAuthenticated = false
        }
    }
}

