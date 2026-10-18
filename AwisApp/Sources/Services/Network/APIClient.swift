import Foundation

public enum NetworkError: LocalizedError {
    case invalidURL
    case serverError(statusCode: Int, message: String)
    case decodingError(Error)
    case unauthorized
    case unknown(Error)

    public var errorDescription: String? {
        switch self {
        case .invalidURL: return "Некорректный адрес запроса"
        case .serverError(let code, let msg): return "Ошибка сервера (\(code)): \(msg)"
        case .decodingError(let err): return "Ошибка декодирования данных: \(err.localizedDescription)"
        case .unauthorized: return "Сессия истекла. Требуется повторный вход"
        case .unknown(let err): return "Ошибка сети: \(err.localizedDescription)"
        }
    }
}

public final class APIClient {
    public static let shared = APIClient()
    public var baseURL = URL(string: "https://api.npu.np.work/")!

    private let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)
    }

    public func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Data? = nil
    ) async throws -> T {
        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
            throw NetworkError.invalidURL
        }

        var req = URLRequest(url: url)
        req.httpMethod = method
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.setValue("Awis-iOS/1.71", forHTTPHeaderField: "User-Agent")

        if let token = AuthManager.shared.accessToken {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        req.httpBody = body

        do {
            let (data, response) = try await session.data(for: req)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.serverError(statusCode: -1, message: "Неизвестный ответ")
            }

            if httpResponse.statusCode == 401 {
                AuthManager.shared.logout()
                throw NetworkError.unauthorized
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                let msg = String(data: data, encoding: .utf8) ?? "Нет описания ошибки"
                throw NetworkError.serverError(statusCode: httpResponse.statusCode, message: msg)
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch let err as NetworkError {
            throw err
        } catch let err as DecodingError {
            throw NetworkError.decodingError(err)
        } catch {
            throw NetworkError.unknown(error)
        }
    }
}
