import Foundation
import Supabase
import Combine

@MainActor
class AuthService: ObservableObject {

    @Published var isAuthenticated: Bool = false
    @Published var authError: String?

    let client: SupabaseClient

    init() {
        client = SupabaseClient(
            supabaseURL: URL(string: "https://iccfajdeeucrppmuqwgf.supabase.co")!,
            supabaseKey: "sb_publishable_hVQm3Y5yQ5RV4KV9sR3Iig_Mem034wP"
        )

        
        Task {
            await restoreSession()
        }
    }

    func restoreSession() async {
        do {
            _ = try await client.auth.session
            isAuthenticated = true
        } catch {
            isAuthenticated = false
        }
    }


    func signIn(email: String, password: String) async throws {
        try await client.auth.signIn(
            email: email,
            password: password
        )
        isAuthenticated = true
    }

    func signUp(email: String, password: String) async throws {
        try await client.auth.signUp(
            email: email,
            password: password
        )
        isAuthenticated = true
    }

    func signOut() async {
        try? await client.auth.signOut()
        isAuthenticated = false
    }
}

