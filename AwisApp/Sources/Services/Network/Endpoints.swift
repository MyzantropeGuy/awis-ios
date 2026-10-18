import Foundation

public struct WarehouseInfoResponse: Codable {
    public let warehouseId: String
    public let name: String
    public let isOnline: Bool
}

public struct OfflineSyncResponse: Codable {
    public let syncId: String
    public let timestamp: Int64
    public let itemsCount: Int
}

public struct SyncSheetsRequest: Codable {
    public let operationId: String
    public let operationType: String
    public let barcodes: [String]
    public let timestamp: Int64
}

public final class AWISAPIService {
    public static let shared = AWISAPIService()
    private let client = APIClient.shared

    private init() {}

    // MARK: - PostOfficeApi equivalents
    public func pingWarehouse(warehouseId: String) async throws -> Bool {
        // GET /warehouse/{id}/ping
        do {
            let res: [String: Bool] = try await client.request(endpoint: "warehouse/\(warehouseId)/ping")
            return res["ok"] ?? true
        } catch {
            return false
        }
    }

    public func fetchWaybill(number: String) async throws -> ExpressWaybill {
        // GET /waybills/{number}
        return try await client.request(endpoint: "waybills/\(number)")
    }

    // MARK: - OfflineWorkplaceApi equivalents
    public func postScanSheets(operation: Operation) async throws -> Bool {
        let req = SyncSheetsRequest(
            operationId: operation.id,
            operationType: operation.type.rawValue,
            barcodes: operation.barcodes,
            timestamp: Int64(operation.timestamp.timeIntervalSince1970 * 1000)
        )
        let body = try JSONEncoder().encode(req)
        let _: [String: String] = try await client.request(endpoint: "workplaces/offline/scan-sheets", method: "POST", body: body)
        return true
    }

    // MARK: - HandbookApi equivalents
    public func fetchHandbook() async throws -> [HandbookItem] {
        return try await client.request(endpoint: "handbook/items")
    }
}
