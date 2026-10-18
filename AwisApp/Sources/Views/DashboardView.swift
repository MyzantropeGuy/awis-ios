import SwiftUI

public struct DashboardView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var dbManager: DatabaseManager

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Card
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Рабочее место AWIS")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text("Отделение: №1, Киев")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.85))
                            }
                            Spacer()
                            Circle()
                                .fill(Color.green)
                                .frame(width: 12, height: 12)
                        }

                        Divider().background(Color.white.opacity(0.3))

                        HStack {
                            Label("\(authManager.currentUser ?? "Сотрудник")", systemImage: "person.circle.fill")
                                .font(.footnote)
                                .foregroundColor(.white)
                            Spacer()
                            Text("Смена открыта")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(6)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .background(Color(red: 0.88, green: 0.15, blue: 0.15))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)

                    // Operational Hub Buttons
                    Text("Операционные модули")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        NavigationLink(destination: PostOfficeView()) {
                            ModuleCard(title: "Отделение", icon: "building.2.crop.circle.fill", count: "\(dbManager.cachedWaybills.count) ЕН", color: .blue)
                        }

                        NavigationLink(destination: OfflineWorkplaceView()) {
                            ModuleCard(title: "Оффлайн склад", icon: "arrow.triangle.2.circlepath.circle.fill", count: "\(dbManager.offlineOperations.count) операций", color: .orange)
                        }

                        NavigationLink(destination: HandbookView()) {
                            ModuleCard(title: "Справочник", icon: "book.circle.fill", count: "\(dbManager.handbookItems.count) кодов", color: .purple)
                        }

                        NavigationLink(destination: QualityControlView()) {
                            ModuleCard(title: "Контроль качества", icon: "checkmark.shield.fill", count: "0 дефектов", color: .green)
                        }
                    }

                    // Recent Waybills
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Последние накладные")
                            .font(.headline)

                        ForEach(dbManager.cachedWaybills.prefix(3)) { wb in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(wb.number)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Text("Мест: \(wb.seatsCount) • Сумма: \(String(format: "%.2f", wb.cost)) грн")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text(wb.isPaid ? "Оплачено" : "К оплате")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(wb.isPaid ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                                    .foregroundColor(wb.isPaid ? .green : .red)
                                    .cornerRadius(6)
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("AWIS 1.71")
        }
    }
}

struct ModuleCard: View {
    let title: String
    let icon: String
    let count: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Text(count)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(14)
    }
}

struct QualityControlView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "camera.viewfinder")
                .font(.system(size: 64))
                .foregroundColor(.green)
            Text("Модуль контроля качества")
                .font(.title2)
                .fontWeight(.bold)
            Text("Фотофиксация повреждений и проверка маркировки грузов.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
        }
        .navigationTitle("Контроль качества")
    }
}
