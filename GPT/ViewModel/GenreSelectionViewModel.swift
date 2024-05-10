//
//  GenreSelectionViewModel.swift
//  GPT
//
//  Created by Alibek Shakirov on 17.04.2024.
//

import Foundation

class GenreSelectionViewModel: ObservableObject {
    @Published var selectedGenres: Set<BookGenre> = []

    init() {
        loadGenresFromUserDefaults()
    }

    func loadGenresFromUserDefaults() {
        if let genresData = UserDefaults.standard.data(forKey: "selectedGenres") {
            if let genres = try? JSONDecoder().decode(Set<BookGenre>.self, from: genresData) {
                selectedGenres = genres
            }
        }
    }
    
    func addNewGenres(newGenres: Set<BookGenre>) {
        let genresData = try? JSONEncoder().encode(newGenres)
        UserDefaults.standard.set(genresData, forKey: "selectedGenres")
    }
}
