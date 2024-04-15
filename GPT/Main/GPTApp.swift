import SwiftUI

@main
struct GPTApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            if appState.selectedGenres.isEmpty {
                GenreSelectionView(selectedGenres: $appState.selectedGenres, isGenreSelectionCompleted: $appState.isGenreSelectionCompleted)
                    .environmentObject(appState)
            } else {
                MainPages()
                    .environmentObject(appState)
            }
            
        }
    }
}

class AppState: ObservableObject {
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


