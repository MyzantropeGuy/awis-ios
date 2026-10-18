import SwiftUI

public struct SettingsView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var dbManager: DatabaseManager
    @State private var serverEndpoint: String = "https://api.npu.np.work/"
    @State private var offlineModeEnabled: Bool = true
    @State private var showResetAlert: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Учетная запись")) {
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.title)
                            .foregroundColor(Color(red: 0.88, green: 0.15, blue: 0.15))
                        VStack(alignment: .leading) {
                            Text(authManager.currentUser ?? "Сотрудник")
                                .font(.headline)
                            Text("ID сессии: \(authManager.accessToken?.prefix(14) ?? "—")...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                    Button("Выйти из профиля") {
                        authManager.logout()
                    }
                    .foregroundColor(.red)
                }

                Section(header: Text("Конфигурация сервера")) {
                    TextField("API Endpoint", text: $serverEndpoint)
                        .font(.footnote)
                    Toggle("Оффлайн-буферизация", isOn: $offlineModeEnabled)
                }

                Section(header: Text("Локальные данные")) {
                    HStack {
                        Text("Кэш накладных")
                        Spacer()
                        Text("\(dbManager.cachedWaybills.count) записей")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Очередь оффлайн-операций")
                        Spacer()
                        Text("\(dbManager.offlineOperations.count) операций")
                            .foregroundColor(.secondary)
                    }

                    Button("Очистить локальный кэш") {
                        showResetAlert = true
                    }
                    .foregroundColor(.red)
                }

                Section(header: Text("О приложении")) {
                    HStack {
                        Text("Версия")
                        Spacer()
                        Text("1.71 (71) iOS Port")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Оригинальный пакет")
                        Spacer()
                        Text("np.ua.reportapp")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Настройки")
            .alert(isPresented: $showResetAlert) {
                Alert(
                    title: Text("Очистить кэш?"),
                    message: Text("Все локальные оффлайн-ведомости будут удалены."),
                    primaryButton: .destructive(Text("Очистить")) {
                        dbManager.loadAll()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}
