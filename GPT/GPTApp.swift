import SwiftUI

@main
struct GPTApp: App {
    
    @StateObject private var appState = AppStateViewModel()
    
    var body: some Scene {
        WindowGroup {
            if appState.selectedGenres.isEmpty {
                GenreSelectionView(selectedGenres: $appState.selectedGenres, isGenreSelectionCompleted: $appState.isGenreSelectionCompleted, appState: appState)
            } else {
                MainPages(appState: appState)
            }
        }
    }
}
