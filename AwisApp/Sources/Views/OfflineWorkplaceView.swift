import SwiftUI

public struct OfflineWorkplaceView: View {
    @EnvironmentObject var dbManager: DatabaseManager
    @State private var selectedOperationType: Operation.OperationType = .cargoTransferReceiving
    @State private var currentBarcodes: [String] = []
    @State private var manualBarcodeInput: String = ""
    @State private var showingScanner: Bool = false
    @State private var isSyncing: Bool = false
    @State private var syncStatusMessage: String? = nil

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Operation Type Selector
                VStack(alignment: .leading, spacing: 6) {
                    Text("Тип операции:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Picker("Операция", selection: $selectedOperationType) {
                        ForEach(Operation.OperationType.allCases, id: \.self) { type in
                            Text(type.localizedTitle).tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                }
                .padding(.horizontal)

                // Input + Scan Bar
                HStack {
                    TextField("Штрихкод груза / паллеты", text: $manualBarcodeInput)
                        .padding(10)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)

                    Button(action: addManualBarcode) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }

                    Button(action: { showingScanner = true }) {
                        Image(systemName: "barcode.viewfinder")
                            .font(.title3)
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color(red: 0.88, green: 0.15, blue: 0.15))
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)

                // Current Session Scans
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Отсканировано в текущую ведомость: \(currentBarcodes.count)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Spacer()
                        if !currentBarcodes.isEmpty {
                            Button("Очистить") { currentBarcodes.removeAll() }
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }

                    if currentBarcodes.isEmpty {
                        Text("Нет отсканированных штрихкодов в буфере.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.vertical, 8)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(currentBarcodes, id: \.self) { barcode in
                                    Text(barcode)
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.blue.opacity(0.15))
                                        .foregroundColor(.blue)
                                        .cornerRadius(6)
                                }
                            }
                        }
                    }

                    if !currentBarcodes.isEmpty {
                        Button(action: saveOperation) {
                            HStack {
                                Image(systemName: "tray.and.arrow.down.fill")
                                Text("Сформировать ведомость")
                            }
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal)

                Divider()

                // Offline Operations History & Sync
                HStack {
                    Text("Журнал оффлайн операций")
                        .font(.headline)
                    Spacer()
                    Button(action: syncAllOperations) {
                        HStack(spacing: 4) {
                            if isSyncing {
                                ProgressView()
                                    .scaleEffect(0.7)
                            } else {
                                Image(systemName: "arrow.triangle.2.circlepath")
                            }
                            Text(isSyncing ? "Синхронизация..." : "Отправить всё")
                        }
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(6)
                    }
                    .disabled(isSyncing)
                }
                .padding(.horizontal)

                List {
                    ForEach(dbManager.offlineOperations) { op in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(op.type.localizedTitle)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                Spacer()
                                Text(op.isSynced ? "Синхронизировано" : "В очереди")
                                    .font(.caption)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(op.isSynced ? Color.green.opacity(0.15) : Color.orange.opacity(0.15))
                                    .foregroundColor(op.isSynced ? .green : .orange)
                                    .cornerRadius(4)
                            }

                            Text("Штрихкодов: \(op.barcodes.count) • ID: \(String(op.id.prefix(8)))...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Оффлайн рабочее место")
            .sheet(isPresented: $showingScanner) {
                BarcodeScannerView { scannedCode in
                    if !currentBarcodes.contains(scannedCode) {
                        currentBarcodes.append(scannedCode)
                    }
                }
            }
        }
    }

    private func addManualBarcode() {
        guard !manualBarcodeInput.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        currentBarcodes.append(manualBarcodeInput.trimmingCharacters(in: .whitespaces))
        manualBarcodeInput = ""
    }

    private func saveOperation() {
        let op = Operation(
            type: selectedOperationType,
            barcodes: currentBarcodes,
            isSynced: false
        )
        dbManager.addOperation(op)
        currentBarcodes.removeAll()
    }

    private func syncAllOperations() {
        isSyncing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            for op in dbManager.offlineOperations {
                dbManager.markOperationSynced(id: op.id)
            }
            self.isSyncing = false
        }
    }
}
