import SwiftUI

struct FavoritesListView: View {
    @Binding var favoriteItems: [FavoriteItem]

    @Environment(\.presentationMode) private var presentationMode
    @State private var isRefreshing = false
    @State private var isEditing = false
    @State private var refreshID = UUID()

    var body: some View {
        NavigationView {
            List {
                ForEach(favoriteItems) { item in
                    Text(item.title)
                }
                .onDelete(perform: deleteFavoriteItem)
                .onMove(perform: moveFavoriteItem)
            }
            .navigationBarTitle("Избранное")
            .navigationBarItems(trailing: HStack(spacing: 240) {
                Button(action: {
                    isEditing.toggle()
                }, label: {
                    Image(systemName: isEditing ? "arrow.up.arrow.down" : "line.horizontal.3").font(.title2)
                })
                Button("Закрыть") {
                    dismiss()
                }
                .offset(x: -15)
            })
            .environment(\.editMode, isEditing ? .constant(.active) : .constant(.inactive))
        }
        .onAppear {
            refreshFavoriteItems()
        }
    }

    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func refreshFavoriteItems() {
        isRefreshing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            favoriteItems = loadFavoriteItems()
            // Trigger list refresh by updating the refreshID
            refreshID = UUID()
            isRefreshing = false
        }
    }

    private func loadFavoriteItems() -> [FavoriteItem] {
        guard let data = UserDefaults.standard.data(forKey: "FavoriteItems") else {
            return []
        }
        
        let decoder = JSONDecoder()
        if let decodedData = try? decoder.decode([FavoriteItem].self, from: data) {
            return decodedData
        }
        
        return []
    }
    
    private func deleteFavoriteItem(at offsets: IndexSet) {
        favoriteItems.remove(atOffsets: offsets)
        saveFavoriteItems()
    }

    private func saveFavoriteItems() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(favoriteItems) {
            UserDefaults.standard.set(encodedData, forKey: "FavoriteItems")
        }
    }

    private func moveFavoriteItem(from source: IndexSet, to destination: Int) {
        favoriteItems.move(fromOffsets: source, toOffset: destination)
        saveFavoriteItems()
    }
}

