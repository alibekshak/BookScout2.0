import SwiftUI

@main
struct GPTApp: App {
    
    @StateObject private var appState = AppStateViewModel()

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
