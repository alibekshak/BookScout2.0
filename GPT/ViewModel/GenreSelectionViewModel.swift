//
//  GenreSelectionViewModel.swift
//  GPT
//
//  Created by Alibek Shakirov on 17.04.2024.
//

import Foundation

class GenreSelectionViewModel: ObservableObject {
    @Published var selectedGenres: [BookGenre] = []
    @Published var originalGenres: [BookGenre] = []
    @Published var userDefaultsEmpty: Bool = false
    

    init() {
        loadGenresFromUserDefaults()
        userDefaultsEmpty = isUserDefaultsEmpty()
    }

    func loadGenresFromUserDefaults() {
        if let genresData = UserDefaults.standard.data(forKey: "selectedGenres") {
            if let genres = try? JSONDecoder().decode(Array<BookGenre>.self, from: genresData) {
                selectedGenres = genres
                originalGenres = genres
            }
        }
    }
    
    func addNewGenres(newGenres: Array<BookGenre>) {
        let genresData = try? JSONEncoder().encode(newGenres)
        UserDefaults.standard.set(genresData, forKey: "selectedGenres")
        originalGenres = newGenres
        userDefaultsEmpty = isUserDefaultsEmpty()
    }
    
    func isUserDefaultsEmpty() -> Bool {
        return UserDefaults.standard.object(forKey: "selectedGenres") == nil
    }
    
    func removeOrInsert(genre: BookGenre) {
        if let index = selectedGenres.firstIndex(of: genre) {
            selectedGenres.remove(at: index)
        } else {
            selectedGenres.append(genre)
        }
    }
    
    func hasChanges() -> Bool {
        return selectedGenres != originalGenres
    }
}
