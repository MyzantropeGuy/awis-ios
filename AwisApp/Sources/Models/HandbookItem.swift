import Foundation

public struct HandbookItem: Identifiable, Codable, Equatable {
    public let id: Int
    public let city: String
    public let main: String
    public let warehouseCode: String

    public init(id: Int, city: String, main: String, warehouseCode: String) {
        self.id = id
        self.city = city
        self.main = main
        self.warehouseCode = warehouseCode
    }
}
