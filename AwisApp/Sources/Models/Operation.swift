import Foundation

public struct Operation: Identifiable, Codable, Equatable {
    public let id: String
    public let type: OperationType
    public let cargoType: String
    public let timestamp: Date
    public var barcodes: [String]
    public var isSynced: Bool

    public enum OperationType: String, Codable, CaseIterable {
        case cargoTransferReceiving = "CargoTransferReceiving"
        case cargoTransferTransmitting = "CargoTransferTransmitting"
        case palletizing = "Palletizing"
        case pickUpInCity = "PickUpInCity"
        case pickUpIntercity = "PickUpIntercity"
        case unloadingInCity = "UnloadingInCity"
        case unloadingIntercity = "UnloadingIntercity"

        public var localizedTitle: String {
            switch self {
            case .cargoTransferReceiving: return "Приемка перемещения"
            case .cargoTransferTransmitting: return "Передача перемещения"
            case .palletizing: return "Паллетирование"
            case .pickUpInCity: return "Забор (город)"
            case .pickUpIntercity: return "Забор (межгород)"
            case .unloadingInCity: return "Разгрузка (город)"
            case .unloadingIntercity: return "Разгрузка (межгород)"
            }
        }
    }

    public init(
        id: String = UUID().uuidString,
        type: OperationType,
        cargoType: String = "Standard",
        timestamp: Date = Date(),
        barcodes: [String] = [],
        isSynced: Bool = false
    ) {
        self.id = id
        self.type = type
        self.cargoType = cargoType
        self.timestamp = timestamp
        self.barcodes = barcodes
        self.isSynced = isSynced
    }
}
