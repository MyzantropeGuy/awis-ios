import Foundation

public struct Cargo: Identifiable, Codable, Equatable {
    public var id: String { barcode }
    public let barcode: String
    public let invoice: String
    public var shelf: String
    public var width: Double
    public var height: Double
    public var length: Double
    public var weight: Double
    public var seatsCount: Int
    public var scannedAt: Date

    public init(
        barcode: String,
        invoice: String = "",
        shelf: String = "",
        width: Double = 0.0,
        height: Double = 0.0,
        length: Double = 0.0,
        weight: Double = 0.0,
        seatsCount: Int = 1,
        scannedAt: Date = Date()
    ) {
        self.barcode = barcode
        self.invoice = invoice
        self.shelf = shelf
        self.width = width
        self.height = height
        self.length = length
        self.weight = weight
        self.seatsCount = seatsCount
        self.scannedAt = scannedAt
    }
}
