//
//  AppStateViewModel.swift
//  GPT
//
//  Created by Alibek Shakirov on 17.04.2024.
//

import Foundation

class AppStateViewModel: ObservableObject {
    @Published var isFirstLaunch = true
    @Published var isGenreSelectionCompleted = false
    @Published var selectedGenres: Set<BookGenre> = []

    init() {
        loadGenresFromUserDefaults()
    }

    private func loadGenresFromUserDefaults() {
        if let genresData = UserDefaults.standard.data(forKey: "selectedGenres") {
            if let genres = try? JSONDecoder().decode(Set<BookGenre>.self, from: genresData) {
                selectedGenres = genres
            }
        }
        isGenreSelectionCompleted = UserDefaults.standard.bool(forKey: "isGenreSelectionCompleted")
    }
}
