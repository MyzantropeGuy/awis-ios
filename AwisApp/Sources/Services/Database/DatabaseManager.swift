import Foundation
import Combine

public final class DatabaseManager: ObservableObject {
    public static let shared = DatabaseManager()

    @Published public var cachedWaybills: [ExpressWaybill] = []
    @Published public var cachedCargo: [Cargo] = []
    @Published public var offlineOperations: [Operation] = []
    @Published public var handbookItems: [HandbookItem] = []

    private let waybillsFile = "awis_cached_waybills.json"
    private let cargoFile = "awis_cached_cargo.json"
    private let operationsFile = "awis_offline_operations.json"
    private let handbookFile = "awis_handbook.json"

    private init() {
        loadAll()
    }

    private func getFileURL(_ filename: String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(filename)
    }

    public func loadAll() {
        self.cachedWaybills = load(waybillsFile) ?? [
            ExpressWaybill(number: "20400012345678", seatsCount: 1, cost: 85.0, payerType: .recipient, paymentMethod: .card, isPaid: false, cargoItems: [
                Cargo(barcode: "2040001234567801", invoice: "20400012345678", shelf: "A-12", weight: 2.5)
            ]),
            ExpressWaybill(number: "20400098765432", seatsCount: 2, cost: 140.0, payerType: .sender, paymentMethod: .nonCash, isPaid: true, cargoItems: [
                Cargo(barcode: "2040009876543201", invoice: "20400098765432", shelf: "B-04", weight: 5.0),
                Cargo(barcode: "2040009876543202", invoice: "20400098765432", shelf: "B-05", weight: 3.2)
            ])
        ]
        self.cachedCargo = load(cargoFile) ?? []
        self.offlineOperations = load(operationsFile) ?? []
        self.handbookItems = load(handbookFile) ?? [
            HandbookItem(id: 1, city: "Киев", main: "Отделение №1 (ул. Пироговский шлях, 135)", warehouseCode: "1/1"),
            HandbookItem(id: 2, city: "Львов", main: "Отделение №1 (ул. Городоцкая, 355)", warehouseCode: "2/1"),
            HandbookItem(id: 3, city: "Одесса", main: "Отделение №1 (ул. Базовая, 16)", warehouseCode: "3/1"),
            HandbookItem(id: 4, city: "Днепр", main: "Отделение №1 (ул. Маршала Малиновского, 114)", warehouseCode: "4/1")
        ]
    }

    public func saveWaybill(_ waybill: ExpressWaybill) {
        if let idx = cachedWaybills.firstIndex(where: { $0.number == waybill.number }) {
            cachedWaybills[idx] = waybill
        } else {
            cachedWaybills.insert(waybill, at: 0)
        }
        persist(cachedWaybills, to: waybillsFile)
    }

    public func addCargo(_ item: Cargo) {
        if let idx = cachedCargo.firstIndex(where: { $0.barcode == item.barcode }) {
            cachedCargo[idx] = item
        } else {
            cachedCargo.insert(item, at: 0)
        }
        persist(cachedCargo, to: cargoFile)
    }

    public func addOperation(_ op: Operation) {
        offlineOperations.insert(op, at: 0)
        persist(offlineOperations, to: operationsFile)
    }

    public func markOperationSynced(id: String) {
        if let idx = offlineOperations.firstIndex(where: { $0.id == id }) {
            offlineOperations[idx].isSynced = true
            persist(offlineOperations, to: operationsFile)
        }
    }

    private func persist<T: Encodable>(_ data: T, to filename: String) {
        do {
            let encoded = try JSONEncoder().encode(data)
            try encoded.write(to: getFileURL(filename))
        } catch {
            print("Failed to persist \(filename): \(error)")
        }
    }

    private func load<T: Decodable>(_ filename: String) -> T? {
        let url = getFileURL(filename)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Failed to load \(filename): \(error)")
            return nil
        }
    }
}
