import SwiftUI


class FavoritesViewModel: ObservableObject {
    private let userDefaultsKey = "FavoriteItems"

    @Published var favoriteItems: [FavoriteItem] {
            didSet {
                saveFavoriteItems()
            }
        }

    init() {
            self.favoriteItems = []
            self.favoriteItems = loadFavoriteItems()
        }

    private func saveFavoriteItems() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(favoriteItems) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
        }
    }

    private func loadFavoriteItems() -> [FavoriteItem] {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            return []
        }
        let decoder = JSONDecoder()
        if let decodedData = try? decoder.decode([FavoriteItem].self, from: data) {
            return decodedData
        }
        return []
    }

    func addToFavorites(item: FavoriteItem) {
        if !favoriteItems.contains(item) {
            favoriteItems.append(item)
        }
    }

    func removeFromFavorites(item: FavoriteItem) {
        if let index = favoriteItems.firstIndex(of: item) {
            favoriteItems.remove(at: index)
        }
    }
}
