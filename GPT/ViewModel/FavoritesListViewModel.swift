//
//  FavoritesListViewModel.swift
//  GPT
//
//  Created by Alibek Shakirov on 26.04.2024.
//

import Foundation
import SwiftUI

class FavoritesListViewModel: ObservableObject {
    
    var vm = FavoritesViewModel()
    
    @Published var favoriteItems: [FavoriteItem]
    @Published var refreshID = UUID()
    
    init() {
        self.favoriteItems = vm.favoriteItems
    }
    
    func refreshFavoriteItems() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.favoriteItems = self.loadFavoriteItems()
            self.refreshID = UUID()
        }
    }

    func loadFavoriteItems() -> [FavoriteItem] {
        guard let data = UserDefaults.standard.data(forKey: "FavoriteItems") else {
            return []
        }
        
        let decoder = JSONDecoder()
        if let decodedData = try? decoder.decode([FavoriteItem].self, from: data) {
            return decodedData
        }
        
        return []
    }
    
    func deleteFavoriteItem(at offsets: IndexSet) {
        favoriteItems.remove(atOffsets: offsets)
        saveFavoriteItems()
    }

    func saveFavoriteItems() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(favoriteItems) {
            UserDefaults.standard.set(encodedData, forKey: "FavoriteItems")
        }
    }

    func moveFavoriteItem(from source: IndexSet, to destination: Int) {
        favoriteItems.move(fromOffsets: source, toOffset: destination)
        saveFavoriteItems()
    }
}
