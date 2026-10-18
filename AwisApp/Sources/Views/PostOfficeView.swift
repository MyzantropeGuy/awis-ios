import SwiftUI

public struct PostOfficeView: View {
    @EnvironmentObject var dbManager: DatabaseManager
    @State private var searchWaybillNumber: String = ""
    @State private var selectedWaybill: ExpressWaybill? = nil
    @State private var showingScanner: Bool = false
    @State private var newShelf: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar + Scanner button
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        TextField("Номер ЕН (14 цифр)", text: $searchWaybillNumber)
                            .keyboardType(.numberPad)
                    }
                    .padding(10)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                    Button(action: { showingScanner = true }) {
                        Image(systemName: "barcode.viewfinder")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color(red: 0.88, green: 0.15, blue: 0.15))
                            .cornerRadius(10)
                    }
                }
                .padding()

                // List of Cached Waybills
                List {
                    ForEach(filteredWaybills) { waybill in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(waybill.number)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Spacer()
                                Text(waybill.isPaid ? "Оплачено" : "\(String(format: "%.2f", waybill.cost)) грн")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(waybill.isPaid ? .green : .red)
                            }

                            HStack {
                                Text("Мест: \(waybill.seatsCount)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)

                                Spacer()

                                Text("Плательщик: \(waybill.payerType.rawValue)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            if !waybill.cargoItems.isEmpty {
                                Divider()
                                ForEach(waybill.cargoItems) { item in
                                    HStack {
                                        Image(systemName: "cube.box")
                                            .foregroundColor(.secondary)
                                        Text(item.barcode)
                                            .font(.caption)
                                        Spacer()
                                        Text("Полка: \(item.shelf.isEmpty ? "—" : item.shelf)")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color.blue.opacity(0.1))
                                            .foregroundColor(.blue)
                                            .cornerRadius(4)
                                    }
                                }
                            }

                            HStack {
                                Button(action: { markPaid(waybill) }) {
                                    Text(waybill.isPaid ? "Отменить оплату" : "Принять оплату")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                        .background(waybill.isPaid ? Color.gray.opacity(0.2) : Color.green)
                                        .foregroundColor(waybill.isPaid ? .primary : .white)
                                        .cornerRadius(8)
                                }
                            }
                            .padding(.top, 4)
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
            .navigationTitle("Рабочее место: Отделение")
            .sheet(isPresented: $showingScanner) {
                BarcodeScannerView { scannedCode in
                    handleScannedCode(scannedCode)
                }
            }
        }
    }

    private var filteredWaybills: [ExpressWaybill] {
        if searchWaybillNumber.isEmpty {
            return dbManager.cachedWaybills
        }
        return dbManager.cachedWaybills.filter { $0.number.contains(searchWaybillNumber) }
    }

    private func handleScannedCode(_ code: String) {
        searchWaybillNumber = code
        // Check if waybill exists, or create new
        if !dbManager.cachedWaybills.contains(where: { $0.number == code }) {
            let newWb = ExpressWaybill(
                number: code,
                seatsCount: 1,
                cost: 95.0,
                payerType: .recipient,
                cargoItems: [Cargo(barcode: "\(code)01", invoice: code, shelf: "C-01", weight: 1.0)]
            )
            dbManager.saveWaybill(newWb)
        }
    }

    private func markPaid(_ waybill: ExpressWaybill) {
        var updated = waybill
        updated.isPaid.toggle()
        dbManager.saveWaybill(updated)
    }
}
