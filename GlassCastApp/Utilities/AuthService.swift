import Foundation
import Supabase
import Combine

@MainActor
final class AuthService: ObservableObject {

    @Published var isAuthenticated = false
    @Published var authError: String?

    let client: SupabaseClient

    init() {
        #if DEBUG
        let isPreview =
            ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        #else
        let isPreview = false
        #endif

        if isPreview {
            client = SupabaseClient(
                supabaseURL: URL(string: "https://preview.supabase.co")!,
                supabaseKey: "preview"
            )
            return
        }

        client = SupabaseClient(
            supabaseURL: URL(string: "https://iccfajdeeucrppmuqwgf.supabase.co")!,
            supabaseKey: "sb_publishable_hVQm3Y5yQ5RV4KV9sR3Iig_Mem034wP"
        )

        Task { await restoreSession() }
    }

    // MARK: - Session Restore
    func restoreSession() async {
        do {
            let session = try await client.auth.session
            isAuthenticated = session.user.emailConfirmedAt != nil
        } catch {
            isAuthenticated = false
        }
    }

    // MARK: - Sign In
    func signIn(email: String, password: String) async throws {
        authError = nil

        let session = try await client.auth.signIn(
            email: email,
            password: password
        )

        isAuthenticated = session.user.emailConfirmedAt != nil
    }


    // MARK: - Sign Up
    func signUp(email: String, password: String) async throws {
        authError = nil
        try await client.auth.signUp(
            email: email,
            password: password
        )
        authError = "Check your email to verify your account"
    }

    // MARK: - Sign Out
    func signOut() {
        Task {
            try? await client.auth.signOut()
            isAuthenticated = false
        }
    }

}

