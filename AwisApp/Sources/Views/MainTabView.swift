import SwiftUI

public struct MainTabView: View {
    @State private var selectedTab: Int = 0

    public var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Главная", systemImage: "square.grid.2x2.fill")
                }
                .tag(0)

            PostOfficeView()
                .tabItem {
                    Label("Отделение", systemImage: "building.2.fill")
                }
                .tag(1)

            OfflineWorkplaceView()
                .tabItem {
                    Label("Оффлайн", systemImage: "wifi.slash")
                }
                .tag(2)

            HandbookView()
                .tabItem {
                    Label("Справочник", systemImage: "book.fill")
                }
                .tag(3)

            SettingsView()
                .tabItem {
                    Label("Настройки", systemImage: "gearshape.fill")
                }
                .tag(4)
        }
        .accentColor(Color(red: 0.88, green: 0.15, blue: 0.15))
    }
}
