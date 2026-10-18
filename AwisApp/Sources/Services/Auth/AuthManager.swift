import Foundation
import Combine
import AuthenticationServices

public final class AuthManager: NSObject, ObservableObject {
    public static let shared = AuthManager()

    @Published public var isAuthenticated: Bool = false
    @Published public var currentUser: String? = nil
    @Published public var accessToken: String? = nil
    @Published public var refreshToken: String? = nil
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil

    private let tokenKey = "awis_access_token"
    private let refreshKey = "awis_refresh_token"
    private let userKey = "awis_current_user"

    private override init() {
        super.init()
        loadPersistedTokens()
    }

    private func loadPersistedTokens() {
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: tokenKey), !token.isEmpty {
            self.accessToken = token
            self.refreshToken = defaults.string(forKey: refreshKey)
            self.currentUser = defaults.string(forKey: userKey) ?? "Сотрудник"
            self.isAuthenticated = true
        }
    }

    public func login(pin: String) {
        isLoading = true
        errorMessage = nil

        // Simulated local auth / PIN verification
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            if pin.count >= 4 {
                let token = "mock_jwt_token_\(UUID().uuidString)"
                self.saveTokens(token: token, refresh: "mock_refresh_\(UUID().uuidString)", user: "Оператор Отделения")
                self.isLoading = false
            } else {
                self.errorMessage = "Неверный PIN-код (минимум 4 цифры)"
                self.isLoading = false
            }
        }
    }

    public func logout() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: tokenKey)
        defaults.removeObject(forKey: refreshKey)
        defaults.removeObject(forKey: userKey)

        self.accessToken = nil
        self.refreshToken = nil
        self.currentUser = nil
        self.isAuthenticated = false
    }

    private func saveTokens(token: String, refresh: String, user: String) {
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: tokenKey)
        defaults.set(refresh, forKey: refreshKey)
        defaults.set(user, forKey: userKey)

        self.accessToken = token
        self.refreshToken = refresh
        self.currentUser = user
        self.isAuthenticated = true
    }
}
