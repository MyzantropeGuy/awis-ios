import Foundation

public struct ExpressWaybill: Identifiable, Codable, Equatable {
    public var id: String { number }
    public let number: String
    public let seatsCount: Int
    public let shouldReturnIndividualControl: Bool
    public var cost: Double
    public var payerType: PayerType
    public var paymentMethod: PaymentMethod
    public var isPaid: Bool
    public var cargoItems: [Cargo]

    public enum PayerType: String, Codable, CaseIterable {
        case sender = "Sender"
        case recipient = "Recipient"
        case thirdPerson = "ThirdPerson"
    }

    public enum PaymentMethod: String, Codable, CaseIterable {
        case cash = "Cash"
        case nonCash = "NonCash"
        case card = "Card"
    }

    public init(
        number: String,
        seatsCount: Int = 1,
        shouldReturnIndividualControl: Bool = false,
        cost: Double = 0.0,
        payerType: PayerType = .recipient,
        paymentMethod: PaymentMethod = .cash,
        isPaid: Bool = false,
        cargoItems: [Cargo] = []
    ) {
        self.number = number
        self.seatsCount = seatsCount
        self.shouldReturnIndividualControl = shouldReturnIndividualControl
        self.cost = cost
        self.payerType = payerType
        self.paymentMethod = paymentMethod
        self.isPaid = isPaid
        self.cargoItems = cargoItems
    }
}
