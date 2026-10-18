import SwiftUI

public struct HandbookView: View {
    @EnvironmentObject var dbManager: DatabaseManager
    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Поиск по городу или коду склада", text: $searchText)
                }
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding()

                List {
                    ForEach(filteredItems) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(item.city)
                                    .font(.headline)
                                Spacer()
                                Text(item.warehouseCode)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Color.purple.opacity(0.15))
                                    .foregroundColor(.purple)
                                    .cornerRadius(6)
                            }
                            Text(item.main)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Справочник отделений")
        }
    }

    private var filteredItems: [HandbookItem] {
        if searchText.isEmpty {
            return dbManager.handbookItems
        }
        return dbManager.handbookItems.filter {
            $0.city.localizedCaseInsensitiveContains(searchText) ||
            $0.main.localizedCaseInsensitiveContains(searchText) ||
            $0.warehouseCode.localizedCaseInsensitiveContains(searchText)
        }
    }
}
