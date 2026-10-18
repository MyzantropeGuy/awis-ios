import SwiftUI

@main
struct AwisApp: App {
    @StateObject private var authManager = AuthManager.shared
    @StateObject private var dbManager = DatabaseManager.shared

    var body: some Scene {
        WindowGroup {
            if authManager.isAuthenticated {
                MainTabView()
                    .environmentObject(authManager)
                    .environmentObject(dbManager)
            } else {
                LoginView()
                    .environmentObject(authManager)
            }
        }
    }
}
