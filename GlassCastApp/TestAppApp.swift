//
//  TestAppApp.swift
//  TestApp
//
//  Created by Amrit Raj on 26/12/25.
//

import SwiftUI


@main
struct GlassCastApp: App {
    @StateObject var authService = AuthService()
    var body: some Scene {
        WindowGroup {
            Group{
                if authService.isAuthenticated{
                    ContentView()
                }
                else {
                    AuthView()
                }
            }
            .environmentObject(authService)
        }
    }
}
